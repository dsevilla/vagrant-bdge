vagrant-bdge
=============

A Vagrantfile to get up and running with Hadoop, HBase, Spark, MySQL,
Pig, Hive, Jupyter, MongoDB and Neo4j development.

Overview
--------

The aim of this project is to set up a virtual machine ready for
Hadoop, HBase and friends development in just a few minutes. The VM is
a Ubuntu 16.04 (wily) box, which is provisioned with
[Ansible](http://www.ansibleworks.com/).

After running `vagrant up`, a single HBase node can be started in
pseudo-distributed mode, running on a single-node Hadoop HDFS
filesystem. A Thrift server can be also started, allowing access from
languages outside of the JVM.

This machine is based on "vagrant-hbase" machine from
[Zbigniew Siciarz](http://siciarz.net/). Github repository:
[vagrant-hbase](https://github.com/zsiciarz/vagrant-hbase).

Getting started
---------------

1. Install Ansible 2.0 or newer on your host machine
2. `git clone https://github.com/dsevilla/vagrant-bdge.git && cd vagrant-bdge && vagrant up`
3. vagrant ssh
4. ./start-{hbase,neo4j,...}.sh
5. PROFIT!

Network and ports
-----------------

The guest machine has a private IP address 192.168.15.166.
HBase-related ports are forwarded. For example, HBase web UIs are
available from the *host* machine at http://127.0.0.1:60010 (Master)
and http://127.0.0.1:60030 (RegionServer).

Hadoop
------

Hadoop 2 is installed by default. If the following commands work, Hadoop is
successfully running.

    vagrant ssh
    cd hadoop/
    echo 'Hello world!' | ./bin/hadoop fs -put - hello.txt
    ./bin/hadoop fs -cat /user/vagrant/hello.txt

Initial data
------------

The `create_test_table.rb` file can be loaded into HBase shell to
define a dead simple test table with one column family `cf`. The table
looks like this:

    +--------+-----------+-----------+
    | rowkey |  cf:col1  |  cf:col2  |
    +========+===========+===========+
    |  row1  |   value1  |
    +--------+-----------+
    |  row2  |   value2  |
    +--------+-----------+-----------+
    |  row3  |           |   value3  |
    +--------+           +-----------+

To load the data, execute:

    vagrant ssh
    cd hbase/
    ./bin/hbase shell /vagrant/data/create_test_table.rb

Jython
------

A Jython interpreter is also installed in the VM. To access Java HBase
API from Jython, you need to set the `CLASSPATH` environment variable
correctly. HBase CLI tool can help in that matter.

    vagrant ssh
    cd hbase/
    export CLASSPATH=`./bin/hbase classpath`
    jython

This should drop you into Jython REPL where you can import Java
classes and use them in a more Pythonic way. An example script that
reads the data loaded with `create_test_table.rb` is at
`/vagrant/test.py`.

Python and HappyBase
--------------------

An alternative approach to access HBase from Python is to use a regular
(CPython) interpreter and Thrift bindings. A Python library called
[HappyBase](https://pypi.python.org/pypi/happybase/) hides away all the
necessary plumbing behind a simple, clean interface to your data. For
your convenience, this package is installed into system-wide Python libraries
when provisioning the guest machine.

An example Python session on the guest machine may look like this (assuming
initial data were loaded):

    vagrant@vagrant-bdge:~$ python
    Python 2.7.3 (default, Apr 10 2013, 05:46:21)
    [GCC 4.6.3] on linux2
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import happybase
    >>> conn = happybase.Connection()
    >>> print conn.tables()
    ['test']
    >>> table = conn.table('test')
    >>> print table.row('row1')
    {'cf:col1': 'value1'}

Author
------

 * [Diego Sevilla](http://neuromancer.inf.um.es/fm) (dsevilla at um dot es)
 * [Zbigniew Siciarz](http://siciarz.net) (zbigniew at siciarz dot
   net) (initial author)

License
-------

This work is released under the MIT license. A copy of the license is provided
in the LICENSE file.
