node 'GroupL-storage.op.ac.nz' {
	include sudo
	package { 'vim': ensure => present }
}

node 'groupl-db.op.ac.nz' {
	include sudo
}

node 'groupl-application.op.ac.nz' {
	include sudo
}

node 'mgmt.groupl.sqrawler.com' {
	include sudo
}
