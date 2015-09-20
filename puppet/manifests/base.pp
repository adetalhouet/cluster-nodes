$deps = [
    'unzip',
    'openjdk-7-jre'
]

package { $deps: ensure   => "installed" }

file { "/etc/environment":
    content => "export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
                export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:\$JAVA_HOME/bin"
}
