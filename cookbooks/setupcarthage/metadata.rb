name             'setupcarthage'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures using chef'
long_description 'Installs/Configures jenkins java maven docker'
version          '0.1.0'
depends  'java', '~> 1.50.0'
depends  'jenkins', '~> 5.0.3'
depends  'maven', '~> 5.0.1'
depends 'git', '~> 6.1.0'
#epends 'apt', '~> 6.1.2'
depends 'docker', '~> 2.0'