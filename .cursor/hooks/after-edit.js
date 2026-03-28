#!/usr/bin/env node
// .cursor/hooks/after-edit.js
// Runs after every agent file edit. Security and integrity checks.

const { execSync } = require('child_process');
const fs = require('fs');

async function main() {
  let input = '';
  process.stdin.on('data', (chunk) => { input += chunk; });
  await new Promise((resolve) => process.stdin.on('end', resolve));

  const ctx = JSON.parse(input || '{}');
  const file = ctx.file_path || '';
  const warnings = [];

  // 1. Security: flag network calls in lib/ that could carry PHI
  if (file.startsWith('lib/') && file.endsWith('.dart')) {
    const content = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
    if (/http\.get\s*\(|http\.post\s*\(|dio\.get\s*\(|dio\.post\s*\(|HttpClient\(\)/.test(content)) {
      warnings.push(
        `SECURITY: Network call in ${file}. VitalPet has zero PHI egress. ` +
        `Verify this is not carrying user health data, symptoms, or check-in history.`
      );
    }
    if (/print\s*\(/.test(content) && /key|token|password|secret/i.test(content)) {
      warnings.push(
        `SECURITY: Possible credential logging in ${file}. Remove before committing.`
      );
    }
  }

  // 2. Check medical filter not bypassed in SLM feature
  if (file.includes('lib/features/slm') && !file.includes('medical_content_filter')) {
    const content = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
    if (/\.prompt\s*=|displayText\s*=|Text\s*\(rawSLM|Text\s*\(raw/.test(content)) {
      if (!/MedicalContentFilter|filterMedical/.test(content)) {
        warnings.push(
          `REVIEW: ${file} may be displaying SLM output without MedicalContentFilter. ` +
          `All SLM-generated strings shown to the user must go through MedicalContentFilter.filter().`
        );
      }
    }
  }

  // 3. Check DB writes are inside transactions
  if (file.includes('lib/') && file.endsWith('.dart')) {
    const content = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
    if (/insertCheckIn\s*\(|\.insert\s*\(checkIn/.test(content) &&
        !/db\.transaction|transaction\s*\(\s*\(\s*\)/.test(content)) {
      warnings.push(
        `DATA INTEGRITY: check-in insert in ${file} detected outside a transaction. ` +
        `All check-in writes must be wrapped in db.transaction(() async { ... }).`
      );
    }
  }

  // 4. Check HealthKit write permissions not requested
  if (file.includes('native/ios/') && file.endsWith('.swift')) {
    const content = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
    if (/toShare:\s*\[(?!\s*\])/.test(content)) {
      warnings.push(
        `HIPAA VIOLATION: HealthKit write permissions in ${file}. ` +
        `toShare: array must be empty: toShare: []. VitalPet is read-only.`
      );
    }
  }

  if (file.includes('native/android/') && file.endsWith('.kt')) {
    const content = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
    if (/getWritePermission/.test(content)) {
      warnings.push(
        `HIPAA VIOLATION: Health Connect write permission in ${file}. ` +
        `Remove all getWritePermission() calls. VitalPet is read-only.`
      );
    }
  }

  // 5. Check that PHI is not written to widget shared container
  if (file.includes('widget_data_writer') || file.includes('WidgetDataProvider')) {
    const content = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
    if (/wellnessScore|answersJson|symptom|checkin_id/i.test(content)) {
      warnings.push(
        `SECURITY: ${file} may be writing PHI to the widget shared container. ` +
        `Only write: petVitality, currentStreak, petState, petName, petSpecies, wellnessSparkline.`
      );
    }
  }

  if (warnings.length > 0) {
    console.log(JSON.stringify({
      followup_message:
        `[VitalPet Hook] ${warnings.length} issue(s) found after editing ${file}:\n\n` +
        warnings.map((w, i) => `${i + 1}. ${w}`).join('\n\n') +
        `\n\nPlease fix before continuing.`
    }));
  } else {
    console.log(JSON.stringify({}));
  }
}

main().catch(() => console.log(JSON.stringify({})));
