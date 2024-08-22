<?php
namespace Deployer;

require 'recipe/common.php';

use Symfony\Component\Console\Input\InputOption;

set('default_timeout', 500);
set('git_ssh_command', 'ssh');

option('generate-new-release', 'i', InputOption::VALUE_OPTIONAL, 'Flag to determine whether a new release must be generated.', false);

desc('Update code from git');
task('warp:git-pull', function () {
    run('cd {{deploy_path}} && git pull --rebase origin {{branch}}');
});

desc('Create new release');
task('warp:new-release', function () {
    if (input()->getOption('generate-new-release') === 'yes') {
        run('cd {{deploy_path}} && bash release.sh');
    }else {
        writeln('No new release requested. Nothing to do.');
    }
});

desc('Execute deployment');
task('deploy', [
    'warp:git-pull',
    'warp:new-release',
]);

import('hosts.yml');
