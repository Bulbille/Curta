/******************************************************************/
// Plan SemiInfini, dynamique de Kawasaki et de Glauber
// Modèle Chipping, hamiltonien SOS
// Parallélisé sur les cisaillements
/******************************************************************/



//Basic stuff
#include <mpi.h>
#include <sys/file.h> //Files lock
#include <random> 
#include <iostream> //cout
#include <sstream> //stringstream
#include <iomanip> // setprecision
#include <fstream> //files
using namespace std;

//Modules diagonalisation de matrices
#include <Eigen/Eigenvalues> 
#include <Eigen/Dense>
using namespace Eigen;
const double T_C    = 2./log(1.+sqrt(2)), J = 1;
double  ttc = 1 ,Beta = 1/(ttc*T_C);
string prefix = "./", suffix = "",algo;
//Propriétés de la grille
const int       bitLX = 7, LX = 2<<bitLX , LY = 200, L_COR = LX/4; 
const int NB_COR = 3e1;
//LX doit être une puissance de 2, 2<<0 = 2, 2<<n = 2^(n+1)
int  Hn = 1;
long int T_EQ = 2e6, T_COR = 1e3,  T_MAX = 1e7;
double Hmax = 1e-1, taux_dyn = 0 ; // 0 : 100% Kawasaki, 1 : 100% Glauber
const double drive =0; 

#include "../prng.h"
#include "../utilitaires.h"

/***********************************/
/**** Définitions des fonctions ****/
double getEquilibrium(int l,double h);
bool EsosGlau(int* array, int x, int ajout,double kbeta,double Champ);
bool EsosKaw(int* array, int x, int ajout,int sens, double kbeta,double Champ,double f); 
void TpsCorrel(double* cor, double* val,int tmax);
double IntCor(double* cor, int tmax);
double LongCorrel(double** val,int lx, int lstep, int nbstep);
/***********************************/

int main(int argc,char* argv[]){
    int rang,nbprocs;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rang);
    MPI_Comm_size(MPI_COMM_WORLD,&nbprocs);
    parametres(argc,argv);


    int Nb_H = Hn/nbprocs;
    double* temps = new double[Nb_H];
    double* tempsTot = new double[Hn];
    double* lambda = new double[Nb_H];
    double* lambdaTot = new double[Hn];

    /***** Parallélisation sur les champs magnétiques ****/
    int cmpt = 0;

    int ajout,sens,tirage,tirage2;
    double dynamique;
    double ene, f, mean,phi,intpart;

    for(int k = rang*Nb_H; k<(rang+1)*Nb_H ; k++){
        f = static_cast<int>(k)*drive/(Hn-1); //Le -1 est pour arriver à Hmax lorsque k = Nb_H au rang supérieur
        if(Hn == 1 )
            f = drive;
        ene = 0,phi=0;
        int* system = new int[LX]; 
        /******** Initialisation du systeme *****/
        mean = getEquilibrium(LY,Hmax);
        system[0] = getEquilibrium(LY,Hmax);
        for(int x = 0;x<LX;x++){ system[x] = system[0];         phi += system[x]; }
        while(phi < mean*LX){    system[rand_lx(generator)]++;  phi++; }
        // Équilibrage
        for(long int t = 0; t<LX*T_EQ ; t++){
            tirage  = rand_lx(generator); ajout   = 2*r01int(generator)-1;
            if(taux_dyn > 0){
                if(EsosGlau(system,tirage,ajout,Beta,Hmax)) system[tirage] += ajout;
            }
            else{
                sens   = 2*r01int(generator)-1;
                if(EsosKaw(system,tirage,ajout,sens,Beta,Hmax,f)){
                    tirage2 = modulo(tirage+sens,LX);
                    system[tirage] += ajout;
                    system[tirage2] -= ajout;
                }
            }
        }
        for(int x=0;x<LX;x++)
            ene += abs(system[x]-system[modulo(x+1,LX)]);

        /****** Calcul du temps de corrélation ***/
        double* energie = new double[T_MAX/LX];
        double* correl = new double[T_MAX/LX];
        for(int t=0;t<T_MAX/LX;t++)
            correl[t] = 0;
        for(int nb = 0 ; nb < NB_COR ; nb++){
            for(long int t = 0; t<T_MAX ; t++){
                tirage  = rand_lx(generator); ajout   = 2*r01int(generator)-1; dynamique = rand_01(generator);
                // Dynamique de Glauber
                if(dynamique < taux_dyn ) {
                    if(EsosGlau(system,tirage,ajout,Beta,Hmax)){
                        ene -= abs(system[tirage]-system[modulo(tirage+1,LX)])+abs(system[tirage]-system[modulo(tirage-1,LX)]);
                        system[tirage] += ajout;
                        ene += abs(system[tirage]-system[modulo(tirage+1,LX)])+abs(system[tirage]-system[modulo(tirage-1,LX)]);
                    }
                }
                // Dynamique de Kawasaki
                else{
                    sens   = 2*r01int(generator)-1;
                    if(EsosKaw(system,tirage,ajout,sens,Beta,Hmax,f)){
                        tirage2 = modulo(tirage+sens,LX);
                        ene -= abs(system[tirage]-system[modulo(tirage-sens,LX)])
                                +abs(system[tirage2]-system[modulo(tirage2+sens,LX)])
                                +abs(system[tirage]-system[tirage2]);
                        system[tirage] += ajout;
                        system[tirage2] -= ajout;
                        ene += abs(system[tirage]-system[modulo(tirage-sens,LX)])
                                +abs(system[tirage2]-system[modulo(tirage2+sens,LX)])
                                +abs(system[tirage]-system[tirage2]);
                    }
                }
                if( modf(t/LX,&intpart) <= 1e-6){
                    energie[static_cast<int>(t/LX)] = ene;
                }
            }
            TpsCorrel(correl,energie,T_MAX/LX);
        }
        temps[cmpt] = IntCor(correl,T_MAX/LX);
        /******* Calcul de la longueur de corrélation ********/
        double** snapshot = new double*[NB_COR];
        //*//
        for(int i=0;i<NB_COR;i++) snapshot[i] = new double[LX];

        for(long int t = 0; t<static_cast<int>(temps[cmpt])*LX*NB_COR ; t++){
            break;
            tirage  = rand_lx(generator); ajout   = 2*r01int(generator)-1; dynamique = rand_01(generator);
            // Dynamique de Glauber
            if(dynamique < taux_dyn ) {
                if(EsosGlau(system,tirage,ajout,Beta,Hmax)){
                    ene -= abs(system[tirage]-system[modulo(tirage+1,LX)])+abs(system[tirage]-system[modulo(tirage-1,LX)]);
                    system[tirage] += ajout;
                    ene += abs(system[tirage]-system[modulo(tirage+1,LX)])+abs(system[tirage]-system[modulo(tirage-1,LX)]);
                }
            }
            // Dynamique de Kawasaki
            else{
                sens   = 2*r01int(generator)-1;
                if(EsosKaw(system,tirage,ajout,sens,Beta,Hmax,f)){
                    tirage2 = modulo(tirage+sens,LX);
                    ene -= abs(system[tirage]-system[modulo(tirage-sens,LX)])
                            +abs(system[tirage2]-system[modulo(tirage2+sens,LX)])
                            +abs(system[tirage]-system[tirage2]);
                    system[tirage] += ajout;
                    system[tirage2] -= ajout;
                    ene += abs(system[tirage]-system[modulo(tirage-sens,LX)])
                            +abs(system[tirage2]-system[modulo(tirage2+sens,LX)])
                            +abs(system[tirage]-system[tirage2]);
                }
            }
//            if( modf(t/(LX*static_cast<int>(temps[cmpt])),&intpart) <= 1e-6){
//                for(int x=0;x<LX;x++)
//                    snapshot[static_cast<int>(intpart)][x] = system[x];
//            }
        }//*/

//        lambda[cmpt] = LongCorrel(snapshot,LX,L_COR,NB_COR);
        delete[] system;
        for(int i=0;i<NB_COR;i++) delete[] snapshot[i];
        delete[] snapshot;
        delete[] energie;
        cmpt++;
    }

    /*** Récupération des calculs parallélisés ****/
    MPI_Gather(temps ,Nb_H,MPI_DOUBLE,tempsTot,Nb_H,MPI_DOUBLE,0,MPI_COMM_WORLD);
    MPI_Gather(lambda ,Nb_H,MPI_DOUBLE,lambdaTot,Nb_H,MPI_DOUBLE,0,MPI_COMM_WORLD);

    if(rang == 0){
        ostringstream streamF,streamH;
        string str;
        streamF << fixed << setprecision(2) << taux_dyn;
        streamH << scientific << setprecision(1) << Hmax;
        str = prefix+"/X"+to_string(LX)+"_H"+streamH.str()+"_F"+streamF.str();
        ofstream fmag(str.c_str(),std::ofstream::app);
        if( Hn == 1)
            fmag << T_MAX << " " << drive << "\t" << tempsTot[0] << " " << lambdaTot[0] << "\n";
        else{
            for(int i=0;i<Hn;i++)
                fmag << i*drive/(Hn-1) << "\t" << tempsTot[i] << " " << lambdaTot[i] << "\n";
        }
    }//*/
    delete[] temps;
    delete[] tempsTot;
    delete[] lambda;
    delete[] lambdaTot;
    MPI_Finalize();
return 0;
}

//        stringstream autre;
//        autre << fixed << setprecision(2) << f;
//        string ssys = prefix+"/system"+autre.str();
//        ofstream fsys(ssys.c_str(),std::ofstream::out);
//        for(int x=0;x<LX;x++)
//            fsys << x << " " << system[x] << "\n";
//        fsys.close();
/***************************************************************/
/************** Fin du main ************************************/
/***************************************************************/

// Diagonalisation de la matrice
double getEquilibrium(int l,double h){
        EigenSolver<MatrixXd> es;
        MatrixXd transfer(l,l);
        MatrixXd diag(l,l);
        for(int i=0;i<l;i++){
                diag(i,i) = i;
            for(int j=0;j<l;j++){
                transfer(i,j) = exp(-Beta*( h*(abs(i)+abs(j))/2 + J*abs(i-j)) );
            }
        }
        int imax = 0;
        double max = 0;
        es.compute(transfer,true);
        VectorXcd a = es.eigenvalues();
        for(int i=0;i<l;i++){
            if(a[i].real()>max){
                imax=i;
                max=a[i].real();
            }
        }
    VectorXcd Vmax = es.eigenvectors().col(imax);
    complex<double> res = Vmax.transpose()*diag*Vmax;
    return res.real();
}
/****** Dynamique de MC *****/
bool EsosGlau(int* array, int x, int ajout,double kbeta,double Champ){
    int hx  = array[x],
        hxp = array[modulo(x+1,LX)],
        hxm = array[modulo(x-1,LX)],
        hx2 = hx+ajout;
    if(hx2<0) return false;
    double champ = Champ*ajout;
    double sos    = J*( abs(hx2-hxm) + abs(hx2-hxp) - (abs(hx - hxm)  +  abs(hx - hxp) ) );

    double D_e   =  exp(-kbeta*(sos+champ));
    return (D_e > 1) ? true : (rand_01(generator) <  D_e );
}

bool EsosKaw(int* array, int x, int ajout,int sens, double kbeta,double Champ,double f){ 
    int hn  = array[modulo(x-sens,LX)],
        hx  = array[modulo(x  ,LX)],
        hxp = array[modulo(x+sens,LX)],
        hnp = array[modulo(x+2*sens,LX)],
        hxf = hx+ajout,
        hxpf= hxp-ajout;
    if(hxf < 0  or hxpf < 0) return false;
    double ef = abs(hn-hxf)  + abs( hxf-hxpf) + abs(hxpf-hnp);
    double ei = abs(hn-hx)  + abs(hx-hxp) + abs(hxp-hnp);
    double sos = J*(ef-ei) + f*sens;

    double D_e = exp(-kbeta*sos);
    return (D_e > 1) ? true : (rand_01(generator) <  D_e );
}

void TpsCorrel(double* cor, double* val, int tmax){
    // Calcul du temps de correlation
    for(int t=0;t<T_COR;t+=1){
        double a=0,b=0,c=0;
        for(int tp=0;tp<tmax-t;tp++){
            a += val[tp]*val[tp+t] ;
            b += val[tp];
            c += val[tp+t];
        }
        cor[t] += a / static_cast<double>(tmax-t) - b * c / static_cast<double>(pow(tmax-t,2)) ;
    }
}
double IntCor(double* cor, int tmax){
    /*** Intégration pour trouver le temps d'autoccorélation ***/
    double tau = 0;
    tmax = 1e3;
    for(int t=0;t<T_COR;t+=1){
        if(t == 0 or t == tmax-1)
            tau += cor[t];
        else if(t % 2 == 0)
            tau += 2*cor[t];
        else
            tau += 4*cor[t];
    }   
    return tau/3/cor[0];
}

double LongCorrel(double** val,int lx, int lstep, int nbstep){
    double tau = 0;
    double* correl = new double[lx/lstep];
    for(int l=0;l<lx/lstep;l++)
        correl[l] = 0;

    for(int i = 0;i<nbstep;i++){
        for(int l=0;l<lx;l+=lstep){
            double a=0,b=0,c=0;
            for(int lp=0;lp<lx-l;lp++){
                a += val[i][lp]*val[i][lp+l] ;
                b += val[i][lp];
                c += val[i][lp+l];
            }
            correl[lx/lstep] += a / static_cast<double>(lx-l) - b * c / static_cast<double>(pow(lx-l,2)) ;
        }   
    }
    for(int l=0;l<lx/lstep;l+=1){
        if(l == 0 or l == lx-1)
            tau += correl[l]/correl[0];
        else if(l % 2 == 0)
            tau += 2*correl[l]/correl[0];
        else
            tau += 4*correl[l]/correl[0];
    }
    return tau/3;
}