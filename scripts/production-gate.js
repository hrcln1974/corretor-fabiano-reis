#!/usr/bin/env node
const { spawnSync } = require('child_process');

const steps = [
  ['Static release audit', ['run','audit:release']],
  ['Syntax check', ['run','check:syntax']],
  ['Functional smoke test', ['run','test:smoke']]
];

let failed = 0;
console.log('╔════════════════════════════════════════════╗');
console.log('║ FABIANO REIS — PREMIUM 2.0.0              ║');
console.log('║ HOSTINGER-ONLY PRODUCTION RELEASE GATE    ║');
console.log('╚════════════════════════════════════════════╝\n');

for (const [label, args] of steps) {
  console.log(`\n▶ ${label}`);
  const r = spawnSync('npm', args, { stdio: 'inherit', shell: process.platform === 'win32' });
  if (r.status !== 0) {
    failed++;
    console.error(`✗ ${label}`);
  } else {
    console.log(`✓ ${label}`);
  }
}

console.log('\n════════════════════════════════════════════');
if (failed) {
  console.error(`PRODUCTION GATE: FAIL — ${failed} etapa(s) falharam.`);
  process.exit(1);
}
console.log('PRODUCTION GATE: PASS');
console.log('PREMIUM 2.0.0 — HOSTINGER READY');
console.log('════════════════════════════════════════════');
