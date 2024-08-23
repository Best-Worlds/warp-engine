<?php
namespace Deployer;

require 'recipe/common.php';

use Symfony\Component\Console\Input\InputOption;

set('default_timeout', 500);
set('git_ssh_command', 'ssh');

option('generate-new-release', 'r', InputOption::VALUE_OPTIONAL, 'Flag to determine whether a new release must be generated.', 'no');
option('rebuild-documentation', 'd', InputOption::VALUE_OPTIONAL, 'Flag to determine whether the docs must be rebuilt (mkdocs).', 'no');

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

desc('Rebuild documentation');
task('warp:rebuild-documentation', function () {
    if (input()->getOption('rebuild-documentation') === 'yes') {
        run('cd {{deploy_path}} && mkdocs build --site-dir {{deploy_path}}/docs');
    }else {
        writeln('Nothing to build at doc level.');
    }
});

desc('Execute deployment');
task('deploy', [
    'warp:git-pull',
    'warp:new-release',
    'warp:rebuild-documentation'
]);

import('hosts.yml');
