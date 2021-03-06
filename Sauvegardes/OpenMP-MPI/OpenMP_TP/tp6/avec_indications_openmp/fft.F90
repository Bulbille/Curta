!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -*- Mode: F90 -*- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! fft.f90 --- TP6 : transform�e de Fourier multiple r�elle-complexe 3D
!!
!! Auteur          : Jalel Chergui (CNRS/IDRIS) <Jalel.Chergui@idris.fr>
!! Cr�� le         : Thu Feb 15 16:04:39 2001
!! Dern. mod. par  : Pierre-Francois Lavallee <lavallee@idris.fr>
!! Dern. mod. le   : Wed Jan 16 16:56:17 2013
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

program fft
!$ use OMP_LIB
implicit none

  integer, parameter                             :: nx=128, ny=200, nz=5000, ldx=nx+1, ldy=nx/2+1
  integer                                        :: code, z_debut, z_fin, z_tranche
!$ integer                                       :: rang, nb_taches, reste
  real(kind=8), dimension(ldx,ny,nz)             :: x, xx
  real(kind=8), allocatable, dimension(:,:,:)    :: temp_x
  complex(kind=8), allocatable, dimension(:,:,:) :: temp_y
  real(kind=8), dimension(100+2*nx)              :: table
  complex(kind=8), allocatable, dimension(:)     :: work
  real(kind=8)      :: ecart, temps, t_cpu_0, t_cpu_1, t_cpu
  integer           :: ir, t1, t2
  external          :: scfftm, csfftm

  !$OMP PARALLEL
  !$ nb_taches = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL
  !$ print '(//,3X,"Execution fft en parallele avec ",i2," threads")',nb_taches
  
  ! Initialisation d'un tableau x.
  call random_number(x) ; xx(:,:,:) = x(:,:,:)

  ! Temps CPU de calcul initial.
  call cpu_time(t_cpu_0)

  ! Temps elapsed de reference.
  call system_clock(count=t1, count_rate=ir)

  ! Initialisation pour le cas d'une ex�cution s�quentielle.
  z_tranche = nz
  z_debut   = 1
  z_fin     = nz

  ! Calcul de la FFT (si parallele, on affecte une tranche d'�l�ments par tache).
  !$OMP...........................................................................

  ! D�termination du rang d'une tache.
  !$ rang = ...

  ! D�termination du nombre totale de taches.
  !$ nb_taches = ...

  ! Calcul du nombre d'�l�ments et des indices de d�but et de fin
  ! d'une tranche dans la direction z.
  !$ reste=mod(nz,nb_taches)
  !$ z_tranche = nz/nb_taches
  !$ if (rang>=reste) then
  !$ z_debut   = rang*z_tranche+reste+1
  !$ z_fin     = (rang+1)*z_tranche+reste
  !$ else
  !$ z_tranche = z_tranche+1
  !$ z_debut   = rang*z_tranche+1
  !$ z_fin     = (rang+1)*z_tranche
  !$ endif

  ! Allocation dynamique de m�moire des tableaux de travail et temporaires.
  allocate(work((4+2*nx)*ny*z_tranche))
  allocate(temp_x(ldx,ny,z_tranche))
  allocate(temp_y(ldy,ny,z_tranche))

  code = 0
  ! Initialisation de la table des coefficients trigonometriques par une seule tache.
  !$OMP...........................................................................
  call scfftm(0,nx,ny*z_tranche,1.0_8,x,ldx,x,ldy,table,work,code)
  !$OMP...........................................................................

  ! Calcul de la FFT directe en parall�le.
  temp_x(:,:,:)=x(:,:,z_debut:z_fin)
  call scfftm(+1, nx, ny*z_tranche, 1.0_8, temp_x, ldx, &
              temp_y, ldy, table, work, code)

  ! Calcul de la FFT inverse en parall�le.
  call csfftm(-1, nx, ny*z_tranche, 1.0_8/real(nx,kind=8), temp_y, ldy, &
              temp_x, ldx, table, work, code)
  x(:,:,z_debut:z_fin)=temp_x(:,:,:)

  ! D�sallocation des tableaux dynamiques.
  deallocate(work, temp_x, temp_y)
  !$OMP...........................................................................

  ! Temps elapsed final.
  call system_clock(count=t2, count_rate=ir)
  temps=real(t2-t1,kind=8)/real(ir,kind=8)

  ! Temps CPU de calcul final
  call cpu_time(t_cpu_1)
  t_cpu = t_cpu_1 - t_cpu_0

  ! V�rification du r�sultat.
  ecart = maxval(abs(x(1:nx,1:ny,1:nz) - xx(1:nx,1:ny,1:nz)))/real(nx*ny*nz,kind=8)

  ! Impression du resultat.
  print '(//,3X,"Ecart FFT |Directe - Inverse| : ",1PE10.3,/  &
           &,3X,"Temps elapsed                 : ",1PE10.3," sec.",/ &
           &,3X,"Temps CPU                     : ",1PE10.3," sec.",//)',ecart,temps,t_cpu

end program fft
