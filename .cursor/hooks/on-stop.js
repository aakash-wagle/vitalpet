#!/usr/bin/env node
// .cursor/hooks/on-stop.js
// Runs when the agent completes. Runs flutter analyze + flutter test.
// On failure, asks the agent to fix and retry (up to 4 iterations).

const { execSync } = require('child_process');
const fs = require('fs');

const MAX_ITERATIONS = 4;
const SCRATCHPAD = '.cursor/scratchpad.md';

async function main() {
  let input = '';
  process.stdin.on('data', (chunk) => { input += chunk; });
  await new Promise((resolve) => process.stdin.on('end', resolve));

  const ctx = JSON.parse(input || '{}');
  const { status, loop_count = 0 } = ctx;

  if (status !== 'completed' || loop_count >= MAX_ITERATIONS) {
    console.log(JSON.stringify({}));
    return;
  }

  if (fs.existsSync(SCRATCHPAD)) {
    const scratchpad = fs.readFileSync(SCRATCHPAD, 'utf8');
    if (scratchpad.includes('DONE')) {
      fs.writeFileSync(SCRATCHPAD, scratchpad.replace('DONE', '').trim());
      console.log(JSON.stringify({}));
      return;
    }
  }

  const failures = [];

  // 1. Run flutter analyze
  try {
    execSync('flutter analyze --no-pub 2>&1', { encoding: 'utf8', timeout: 60000 });
  } catch (e) {
    const out = e.stdout || e.message || '';
    const errors = out.split('\n')
      .filter(l => l.includes('error •') || l.includes('error -'))
      .slice(0, 6);
    if (errors.length > 0) {
      failures.push(`flutter analyze errors:\n${errors.join('\n')}`);
    }
  }

  // 2. Run flutter test (only if analyze passes)
  if (failures.length === 0) {
    try {
      execSync('flutter test --no-pub 2>&1', { encoding: 'utf8', timeout: 180000 });
    } catch (e) {
      const out = e.stdout || e.message || '';
      const testFailures = out.split('\n')
        .filter(l => l.startsWith('FAILED') || l.includes('Expected:') || l.includes('✗'))
        .slice(0, 8);
      if (testFailures.length > 0) {
        failures.push(`flutter test failures:\n${testFailures.join('\n')}`);
      }
    }
  }

  // 3. Check for generated code out of date (drift / Riverpod)
  try {
    const result = execSync(
      'dart run build_runner build --delete-conflicting-outputs --dry-run 2>&1',
      { encoding: 'utf8', timeout: 30000 }
    );
    if (result.includes('would be generated')) {
      failures.push(
        `Code generation is out of date. Run:\n` +
        `dart run build_runner build --delete-conflicting-outputs`
      );
    }
  } catch (_) {}

  if (failures.length > 0) {
    console.log(JSON.stringify({
      followup_message:
        `[VitalPet Hook — iteration ${loop_count + 1}/${MAX_ITERATIONS}] ` +
        `Quality checks failed. Please fix:\n\n` +
        failures.join('\n\n') +
        `\n\nVerify manually:\n` +
        `- flutter analyze\n- flutter test\n` +
        `- dart run build_runner build --delete-conflicting-outputs\n\n` +
        `When all pass, write DONE to .cursor/scratchpad.md.`
    }));
  } else {
    console.log(JSON.stringify({}));
  }
}

main().catch(() => console.log(JSON.stringify({})));
