#! /bin/sh

OUTDIR=/home/dsevilla/otro/dsevilla/webfsd
OUTPUTBOX=$OUTDIR/bdge.box
#VMNAME=$(VBoxManage list vms | grep vagrant-bdge | cut -d\  -f1  | tr -d \")

# Copy documentation
vagrant up
vagrant ssh -c 'mkdir doc'

# Obtain ssh configuration information
F=$(mktemp -t vagrant-ssh-config-XXXX)
vagrant ssh-config >$F

test -e $OUTPUTBOX && rm $OUTPUTBOX
if vagrant package --output $OUTPUTBOX --vagrantfile ../Vagrantfile
then
  SHA1=`openssl sha1 $OUTPUTBOX | cut -d\  -f2`
  jq ".versions[0].providers[0].checksum=\"$SHA1\"" < bdge.json >$OUTDIR/bdge.json
  cp ../Vagrantfile $OUTDIR/Vagrantfile
  cp ChangeLog $OUTDIR/
fi

exit 0
