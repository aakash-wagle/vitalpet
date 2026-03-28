# Daily check-in schema

## DailyCheckIn (root)

### Core
| Field | Type | Notes |
|---|---|---|
| `timestamp` | ISO8601 | |
| `overall_status` | `"great" \| "not_great"` | |
| `streak_day` | integer | |

---

### symptoms[]
Only populated if `overall_status = "not_great"`.

#### SymptomBase (shared by all categories)
| Field | Type | Notes |
|---|---|---|
| `category` | `"fever" \| "pain" \| "fatigue" \| "nausea" \| "other"` | |
| `pattern` | enum | Category-specific allowed values (see below) |
| `onset_day` | integer | Computed from check-in history — never asked |

---

#### Fever
| Field | Type | Notes |
|---|---|---|
| `temperature` | float? | |
| `unit` | `"C" \| "F"` ? | |
| `method` | `"oral" \| "ear" \| "forehead" \| "other"` ? | |
| `pattern` | `"constant" \| "intermittent" \| "night_only"` | |
| `skipped` | boolean | True if user has no thermometer |

---

#### Pain
| Field | Type | Notes |
|---|---|---|
| `regions[]` | `body_region_enum[]` | Multi-select from body map |
| `type` | `"sharp" \| "dull" \| "throbbing" \| "burning" \| "cramping" \| "aching"` | |
| `triggers[]` | `("movement" \| "eating" \| "breathing" \| "touch" \| "none")[]` ? | Optional |
| `pattern` | `"constant" \| "comes_and_goes" \| "worsening" \| "improving"` | |

---

#### Fatigue
| Field | Type | Notes |
|---|---|---|
| `scope` | `"functional" \| "wiped_out" \| "debilitating"` | |
| `blocks_daily` | boolean | "Does it stop you doing normal things?" |
| `pattern` | `"morning_only" \| "afternoon_crash" \| "all_day" \| "post_exertion"` | |

---

#### Nausea
| Field | Type | Notes |
|---|---|---|
| `vomiting` | boolean | |
| `vomit_freq` | `"once" \| "few_times" \| "persistent"` ? | Only if `vomiting = true` |
| `appetite` | `"normal" \| "reduced" \| "none"` | |
| `dehydration_signs[]` | `("dry_mouth" \| "dark_urine" \| "dizziness")[]` ? | |
| `pattern` | `"constant" \| "after_eating" \| "morning" \| "wave_like"` | |

---

#### Other
| Field | Type | Notes |
|---|---|---|
| `free_text` | string | Mandatory for this category |
| `extracted_details` | `Partial<Fever \| Pain \| Fatigue \| Nausea>` ? | Best-effort SLM parse |

---

### Subjective (optional — SLM territory)
| Field | Type | Notes |
|---|---|---|
| `free_notes` | string? | End-of-check-in free text |
| `slm_tags[]` | string[]? | Keywords extracted from `free_notes` |
| `follow_up_exchanges[]` | `ConversationTurn[]`? | Raw SLM conversation turns |

```ts
type ConversationTurn = {
  role: "user" | "assistant";
  content: string;
  timestamp: ISO8601;
}
```

---

### Context (from World document — referenced, not re-entered daily)
| Field | Type | Notes |
|---|---|---|
| `active_conditions[]` | string ref[] | Conditions active at check-in time |
| `tracked_metrics[]` | `{ label: string, value?: string }[]` | User-defined metrics e.g. "HbA1c due date" |

---

## Design notes
- `pattern` is a shared base field on every symptom; allowed enum values are category-specific.
- `onset_day` is computed (days since first recorded instance of that category) — never surfaced as a question.
- `skipped: true` on fever signals intentional omission (no thermometer), distinct from a missing value.
- `follow_up_exchanges` stores raw turns to allow SLM conversation replay or re-processing.
- `Other` is the escape hatch for health-literate users; `extracted_details` allows the SLM to back-parse free text into structured fields.