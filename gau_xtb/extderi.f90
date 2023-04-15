!This tool was written by Dr. Tian Lu at Beijing Kein Research Center for Natural Sciences (www.keinsci.com)
!Contact: sobereva@sina.com

program extderi
implicit real*8 (a-h,o-z)
character*80 outname,c80,arg2,arg3
real*8 polar(6)
real*8,allocatable :: ddip(:),hess(:,:)

call getarg(1,outname)
call getarg(2,arg2)
call getarg(3,arg3)
read(arg2,*) natm
read(arg3,*) ider !1=only force 2=also Hessian

open(11,file=outname,status="replace")

open(10,file="energy",status="old")
read(10,*)
read(10,*) inouse,ene
write(11,"(4D20.12)") ene,0D0,0D0,0D0
close(10)

open(10,file="gradient",status="old")
read(10,*)
read(10,*)
do iatm=1,natm
	read(10,*)
end do
do iatm=1,natm
	read(10,*) fx,fy,fz
	write(11,"(3D20.12)") fx,fy,fz
end do
close(10)

if (ider==2) then
	polar=0
	write(11,"(3D20.12)") polar
	allocate(ddip(9*natm))
	ddip=0
	write(11,"(3D20.12)") ddip
	allocate(hess(3*natm,3*natm))
	open(10,file="hessian",status="old")
	read(10,*)
	read(10,*) ((hess(i,j),j=1,3*natm),i=1,3*natm)
	write(11,"(3D20.12)") ((hess(i,j),j=1,i),i=1,3*natm)
	close(10)
end if
close(11)
end program
