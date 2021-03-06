bool isOnlyDouble(const char* str);
void parametres(int argc, char* argv[]);
int modulo(int a, int b); 
int fact(int n);
double lnfact(int n);

/******* Fonctions utilitaires *****/
void parametres(int argc, char* argv[]){
    if(argc > 1){ 
        for(int i = 1; i<argc; ++i){
            std::string arg = argv[i];
            if(arg == "-t"){
                if(isOnlyDouble(argv[i+1])){
                    ttc = atof(argv[i+1]);
                    Beta = 1/(ttc*T_C);
                }
            }
            else if(arg == "-h"){
                if(isOnlyDouble(argv[i+1]))
                    Hmax = atof(argv[i+1]);
            }
            else if(arg == "-prefix"){
                prefix = argv[i+1];
            }
            else if(arg == "-f"){
                if(isOnlyDouble(argv[i+1]))
                    taux_dyn = static_cast<double>(atof(argv[i+1]));
            }
            else if(arg == "-suffix"){
                suffix = argv[i+1];
            }
        }
    }   
    if(taux_dyn >0) 
        T_MAX /= taux_dyn;
    if(system(("mkdir -p " + prefix).c_str())) {;} 
}
/*** Modulo **/
int modulo(int a, int b){ 
    while(a < 0 or a >= b){ 
        if(a<0) a+= b;
        else if(a >= b) a-=b;
    }   
    return a;
}
int fact(int n) { 
    if ((n==0)||(n==1))
        return 1; 
    else
        return n*fact(n-1);
}
double lnfact(int n){
    if(n<5) 
        return fact(n);
    else 
        return n*log(n)-n;
}

bool isOnlyDouble(const char* str){
    char* endptr = 0;
    strtod(str, &endptr);

    if(*endptr != '\0' || endptr == str)
        return false;

    return true;
}


