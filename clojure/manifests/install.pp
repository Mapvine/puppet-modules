class clojure::install {

  require clojure::params
  $packages = ["leiningen"]
  package { $packages:
        ensure => latest,
  }


}
