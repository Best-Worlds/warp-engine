<?php
namespace Deployer;

require 'recipe/common.php';

set('default_timeout', 500);
set('git_ssh_command', 'ssh');


desc('Update code from git');
task('warp:git-pull', function () {
    run('git pull --rebase origin bestworlds');
});

desc('Create new release');
task('warp:new-release', function () {
    run('bash release.sh');
});

desc('Execute deployment');
task('deploy', [
    'warp:git-pull',
    'warp:new-release',
]);

import('hosts.yml');
