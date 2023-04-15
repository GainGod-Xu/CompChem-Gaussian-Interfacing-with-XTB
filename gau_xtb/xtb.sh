
#This script was written by Dr. Tian Lu at Beijing Kein Research Center for Natural Sciences (www.keinsci.com)
#Contact: sobereva@sina.com

read atoms derivs charge spin < $2

#Create temporary .xyz file
#the element index should be replaced with element name, and the coordinate should be convert to Angstrom
echo "Generating mol.tmp"
cat >> mol.tmp <<EOF
$atoms

$(sed -n 2,$(($atoms+1))p < $2 | cut -c 1-72)
EOF

echo "Generating mol.xyz via genxyz"
/gsfs0/data/xuhq/gau_xtb_2/genxyz

rm -f mol.tmp

rm -f charges energy xtbrestart gradient hessian xtbout
rm -f hessian xtb_normalmodes g98_canmode.out g98.out wbo xtbhess.coord

uhf=`echo "$spin-1" | bc` #nalpha-nbeta
if [ $derivs == "2" ] ; then
	echo "Running: xtb mol.xyz --chrg $charge --uhf $uhf --hess --grad > xtbout"
	 /gsfs0/data/xuhq/xtb_yl/bin/xtb mol.xyz --chrg $charge --uhf $uhf --hess --grad > xtbout
elif [ $derivs == "1" ] ; then
	echo "Running: xtb mol.xyz --chrg $charge --uhf $uhf --grad > xtbout"
	 /gsfs0/data/xuhq/xtb_yl/bin/xtb mol.xyz --chrg $charge --uhf $uhf --grad > xtbout
fi
echo "xtb running finished!"

echo "Extracting data from xtb outputs via extderi"
/gsfs0/data/xuhq/gau_xtb_2/extderi $3 $atoms $derivs

cp mol.xyz mol_opt.xyz

rm -f charges energy xtbrestart gradient hessian xtbout mol.xyz tmpxx vibspectrum
rm -f hessian xtb_normalmodes g98_canmode.out g98.out wbo xtbhess.coord .tmpxtbmodef


