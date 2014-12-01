class nixmentors {

  package {
   [
     'vim',
     'git',
     'screen',
     'htop',
   ]:
    ensure => latest,
  }

}
