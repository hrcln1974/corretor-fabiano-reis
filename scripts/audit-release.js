const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const root = path.resolve(__dirname, '..');
const forbidden = [
  '.env', 'database.db', 'database.db-wal', 'database.db-shm',
  'node_modules', '.git', 'release'
];
const required = [
  'package.json', 'package-lock.json', 'server.js', 'db-adapter.js',
  'db-sqlite-node.js', 'storage/index.js', 'public/index.html',
  'public/dashboard.html', 'public/crm.html', 'public/robots.txt',
  'public/sitemap.xml', '.env.example', 'DEPLOY-HOSTINGER.md'
];
const secretPatterns = [
  /ADMIN_PASSWORD\s*=\s*(?!COLOQUE_|CHANGE_ME|SEU_|<)[^\s#]+/i,
  /JWT_SECRET\s*=\s*(?!COLOQUE_AQUI|CHANGE_ME|SEU_|<)[^\s#]{20,}/i,
  /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/
];
const forbiddenProviderPatterns = [
  /@vercel\/blob/i, /@neondatabase\/serverless/i,
  /\bvercel\.json\b/i, /\bvercel\b/i, /\bneon\b/i
];

let failures = 0;
const ok = msg => console.log(`✓ ${msg}`);
const fail = msg => { failures++; console.error(`✗ ${msg}`); };

function trackedFiles() {
  try {
    return execFileSync('git', ['ls-files', '-z'], {
      cwd: root, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore']
    }).split('\0').filter(Boolean);
  } catch (_) {
    return null;
  }
}

const gitFiles = trackedFiles();
if (gitFiles) {
  for (const item of forbidden) {
    if (gitFiles.includes(item) || gitFiles.some(f => f.startsWith(`${item}/`))) fail(`artefato proibido versionado: ${item}`);
    else ok(`não versionado: ${item}`);
  }
} else {
  ok('Git não presente — auditoria do pacote físico ativada');
  for (const item of forbidden) {
    if (fs.existsSync(path.join(root, item))) fail(`artefato proibido no pacote: ${item}`);
    else ok(`ausente do pacote: ${item}`);
  }
}

for (const item of required) {
  if (fs.existsSync(path.join(root, item))) ok(`arquivo obrigatório: ${item}`);
  else fail(`arquivo obrigatório ausente: ${item}`);
}

const envExamplePath = path.join(root, '.env.example');
if (fs.existsSync(envExamplePath)) {
  const envExample = fs.readFileSync(envExamplePath, 'utf8');
  if (secretPatterns.some(re => re.test(envExample))) fail('segredo real detectado no .env.example');
  else ok('nenhum segredo real detectado no .env.example');
}

const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
if (pkg.scripts?.start === 'node server.js') ok('start compatível com Hostinger Node.js');
else fail('script start inesperado');

if (pkg.engines?.node && String(pkg.engines.node) === '>=22.5 <25') ok(`engine Node declarada: ${pkg.engines.node}`);
else fail(`engine Node deve ser >=22.5 <25 (atual: ${pkg.engines?.node || 'ausente'})`);

const providerFiles = [];
const runtimeScanFiles = [
  'package.json', 'package-lock.json', 'server.js', 'db-adapter.js',
  'db-sqlite-node.js', 'storage/index.js'
];
for (const rel of runtimeScanFiles) {
  const full = path.join(root, rel);
  if (!fs.existsSync(full)) continue;
  const text = fs.readFileSync(full, 'utf8');
  if (forbiddenProviderPatterns.some(re => re.test(text))) providerFiles.push(rel);
}
const unexpected = providerFiles;
if (unexpected.length) fail(`referências Vercel/Neon detectadas: ${unexpected.join(', ')}`);
else ok('nenhuma dependência/referência Vercel/Neon detectada no pacote');

const serverPath = path.join(root, 'server.js');
if (fs.existsSync(serverPath)) {
  const server = fs.readFileSync(serverPath, 'utf8');
  for (const marker of ['Content-Security-Policy','HttpOnly','SameSite=Lax','X-Content-Type-Options','/health']) {
    if (server.includes(marker)) ok(`hardening presente: ${marker}`);
    else fail(`hardening ausente: ${marker}`);
  }
}

if (failures) {
  console.error(`AUDIT RELEASE: ${failures} falha(s).`);
  process.exit(1);
}
console.log('\nAUDIT RELEASE: OK — pacote Hostinger-only apto para publicação após configurar o ambiente.');
