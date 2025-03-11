#! /bin/sh

# recompile
cmake .
make clean
make

mkdir -p exforth/share

# move files
mv fth/exforth_standalone exforth/
cp fth/ex_local_share/* exforth/share

# ad install script
cat > exforth/install.sh <<EOF
#! /bin/sh

if [ "\$1" == "--local" ]; then

   mkdir -p "\$HOME/.local/bin/"
   mv exforth_standalone "\$HOME/.local/bin/exforth"

   mkdir -p "\$HOME/.local/share"
   mv share/* "\$HOME/.local/share/exforth/"
   rmdir share

else
   if [ "\$(whoami)" != "root" ]; then
      echo "Cannot install globally!"
      echo "Either run with superuser privileges, or use the --local flag."
      exit
   fi

   mv exforth_standalone /usr/local/bin/exforth

   mkdir -p /usr/local/share/exforth
   mv share/* /usr/local/share/exforth/
   rmdir share
fi

EOF

chmod u+x exforth/install.sh

# tar and remove
tar -czf exforth.tar.gz exforth
rm -fr exforth
