[1mdiff --git a/scripts/audit-release.js b/scripts/audit-release.js[m
[1mnew file mode 100644[m
[1mindex 0000000..eb68948[m
[1m--- /dev/null[m
[1m+++ b/scripts/audit-release.js[m
[36m@@ -0,0 +1,152 @@[m
[32m+[m[32mconst fs = require('fs');[m
[32m+[m[32mconst path = require('path');[m
[32m+[m[32mconst { execFileSync } = require('child_process');[m
[32m+[m
[32m+[m[32mconst root = path.resolve(__dirname, '..');[m
[32m+[m
[32m+[m[32mconst forbiddenTracked = [[m
[32m+[m[32m  '.env',[m
[32m+[m[32m  'database.db',[m
[32m+[m[32m  'database.db-wal',[m
[32m+[m[32m  'database.db-shm',[m
[32m+[m[32m];[m
[32m+[m
[32m+[m[32mconst forbiddenTrackedPrefixes = [[m
[32m+[m[32m  'node_modules/',[m
[32m+[m[32m  '.git/',[m
[32m+[m[32m  'release/',[m
[32m+[m[32m];[m
[32m+[m
[32m+[m[32mconst required = [[m
[32m+[m[32m  'package.json',[m
[32m+[m[32m  'package-lock.json',[m
[32m+[m[32m  'server.js',[m
[32m+[m[32m  'db-adapter.js',[m
[32m+[m[32m  'storage/index.js',[m
[32m+[m[32m  'public/index.html',[m
[32m+[m[32m  'public/dashboard.html',[m
[32m+[m[32m  'public/crm.html',[m
[32m+[m[32m  'public/robots.txt',[m
[32m+[m[32m  'public/sitemap.xml',[m
[32m+[m[32m  '.env.example',[m
[32m+[m[32m  'DEPLOY-HOSTINGER.md',[m
[32m+[m[32m];[m
[32m+[m
[32m+[m[32mconst secretPatterns = [[m
[32m+[m[32m  /ADMIN_PASSWORD\s*=\s*(?!COLOQUE_|CHANGE_ME|SEU_|<)[^\s#]+/i,[m
[32m+[m[32m  /JWT_SECRET\s*=\s*(?!COLOQUE_AQUI|CHANGE_ME|SEU_|<)[^\s#]{20,}/i,[m
[32m+[m[32m  /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/,[m
[32m+[m[32m];[m
[32m+[m
[32m+[m[32mlet failures = 0;[m
[32m+[m
[32m+[m[32mconst ok = msg => console.log(`✓ ${msg}`);[m
[32m+[m[32mconst fail = msg => {[m
[32m+[m[32m  failures++;[m
[32m+[m[32m  console.error(`✗ ${msg}`);[m
[32m+[m[32m};[m
[32m+[m
[32m+[m[32mfunction getTrackedFiles() {[m
[32m+[m[32m  try {[m
[32m+[m[32m    return execFileSync([m
[32m+[m[32m      'git',[m
[32m+[m[32m      ['ls-files', '-z'],[m
[32m+[m[32m      {[m
[32m+[m[32m        cwd: root,[m
[32m+[m[32m        encoding: 'utf8',[m
[32m+[m[32m        stdio: ['ignore', 'pipe', 'pipe'],[m
[32m+[m[32m      }[m
[32m+[m[32m    )[m
[32m+[m[32m      .split('\0')[m
[32m+[m[32m      .filter(Boolean);[m
[32m+[m[32m  } catch (error) {[m
[32m+[m[32m    fail('não foi possível consultar os arquivos versionados pelo Git');[m
[32m+[m[32m    return [];[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mconst trackedFiles = getTrackedFiles();[m
[32m+[m
[32m+[m[32mfor (const item of forbiddenTracked) {[m
[32m+[m[32m  if (trackedFiles.includes(item)) {[m
[32m+[m[32m    fail(`artefato proibido versionado: ${item}`);[m
[32m+[m[32m  } else {[m
[32m+[m[32m    ok(`não versionado: ${item}`);[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mfor (const prefix of forbiddenTrackedPrefixes) {[m
[32m+[m[32m  const found = trackedFiles.some(file => file.startsWith(prefix));[m
[32m+[m
[32m+[m[32m  if (found) {[m
[32m+[m[32m    fail(`artefato proibido versionado: ${prefix}`);[m
[32m+[m[32m  } else {[m
[32m+[m[32m    ok(`não versionado: ${prefix}`);[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mfor (const item of required) {[m
[32m+[m[32m  if (fs.existsSync(path.join(root, item))) {[m
[32m+[m[32m    ok(`arquivo obrigatório: ${item}`);[m
[32m+[m[32m  } else {[m
[32m+[m[32m    fail(`arquivo obrigatório ausente: ${item}`);[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mconst envExamplePath = path.join(root, '.env.example');[m
[32m+[m
[32m+[m[32mif (fs.existsSync(envExamplePath)) {[m
[32m+[m[32m  const envExample = fs.readFileSync(envExamplePath, 'utf8');[m
[32m+[m
[32m+[m[32m  if (secretPatterns.some(re => re.test(envExample))) {[m
[32m+[m[32m    fail('segredo real detectado no .env.example');[m
[32m+[m[32m  } else {[m
[32m+[m[32m    ok('nenhum segredo real detectado no .env.example');[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mconst pkg = JSON.parse([m
[32m+[m[32m  fs.readFileSync(path.join(root, 'package.json'), 'utf8')[m
[32m+[m[32m);[m
[32m+[m
[32m+[m[32mif (pkg.scripts?.start === 'node server.js') {[m
[32m+[m[32m  ok('start compatível com Hostinger Node.js');[m
[32m+[m[32m} else {[m
[32m+[m[32m  fail('script start inesperado');[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mif (pkg.engines?.node && String(pkg.engines.node).includes('20')) {[m
[32m+[m[32m  ok(`engine Node declarada: ${pkg.engines.node}`);[m
[32m+[m[32m} else {[m
[32m+[m[32m  fail('engine Node 20+ não declarada');[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mconst serverPath = path.join(root, 'server.js');[m
[32m+[m
[32m+[m[32mif (fs.existsSync(serverPath)) {[m
[32m+[m[32m  const server = fs.readFileSync(serverPath, 'utf8');[m
[32m+[m
[32m+[m[32m  for (const marker of [[m
[32m+[m[32m    'Content-Security-Policy',[m
[32m+[m[32m    'HttpOnly',[m
[32m+[m[32m    'SameSite=Lax',[m
[32m+[m[32m    'X-Content-Type-Options',[m
[32m+[m[32m    '/health',[m
[32m+[m[32m  ]) {[m
[32m+[m[32m    if (server.includes(marker)) {[m
[32m+[m[32m      ok(`hardening presente: ${marker}`);[m
[32m+[m[32m    } else {[m
[32m+[m[32m      fail(`hardening ausente: ${marker}`);[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mif (failures > 0) {[m
[32m+[m[32m  console.error(`AUDIT RELEASE: ${failures} falha(s).`);[m
[32m+[m[32m  process.exit(1);[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mconsole.log('');[m
[32m+[m[32mconsole.log([m
[32m+[m[32m  'AUDIT RELEASE: OK — workspace e conteúdo versionado aptos para publicação.'[m
[32m+[m[32m);[m
