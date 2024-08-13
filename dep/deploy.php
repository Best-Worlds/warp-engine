<?php
namespace Deployer;

require 'recipe/common.php';

set('default_timeout', 500);
set('git_ssh_command', 'ssh');

desc('Create new release');
task('warp:new-release', function () {
    //run('bash release.sh');
    run('ls -la');
});

desc('Execute deployment');
task('deploy', [
    'warp:new-release',
]);

after('deploy', 'success');

import('hosts.yml');
