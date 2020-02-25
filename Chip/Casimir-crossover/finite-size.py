#!/usr/bin/python
# -*- coding: utf8

#########################################
# Modèle d'interface en histogramme
#########################################
import matplotlib.pyplot as plt
fontsize=10
plt.rc("font",size=fontsize)
plt.rc("font",family='serif')

import scipy as sy
import scipy.special as sp
import scipy.integrate as integrate
from scipy.optimize import curve_fit
import numpy as np
import numpy.linalg as linalg
from pylab import *
import os #pour les chemins de fichiers
import sys #pour l'exit et l'argument
import re

directory=sys.argv[1]
regex_chain="T-([\d.]+)(?:-\d)?(?:-t[\d.]*)?(?:-h-([\d.]+))?(?:-lx-([\d.]+))?"
TC  = 2/np.log(1.+np.power(2,0.5))
J   = 1
LX  = 100
LY  = 20*2+1
colors=['red','blue','green','rosybrown','sandybrown','gold','olivedrab','palegreen','lightseagreen','darkcyan','royalblue','navy','plum','coral','orange','olive','g','c','dodgerblue','violet','fuchsia','crimson','peru','goldenrod','forestgreen','aquamarine','aqua','blueviolet','pink','tomato','linen','antiquewhite','yellow','greenyellow','lime','cyan','indigo','darkmagenta']
fmt=["-",":","--", "-.","-",":","--", "-.","-",":","--", "-."] #linestyle
nb_color = size(colors)


###############################
# Liste des températures et 
# des longueur magnétiques 
###############################
temp = []
longueur = []
champ  = []

for file in sorted(os.listdir(directory)):
	a=False
	b=False
	regex = re.search(regex_chain,file)
	if regex == None : 
		continue
	res = re.findall(regex_chain,file)
	if float(res[0][0]) not in temp:
            temp = np.append(temp,float(res[0][0]))
	if bool(res[0][1]) :
	    if float(res[0][1]) not in champ :
                champ   = np.append(champ,float(res[0][1]))
        else :
	    if 0 not in champ :
                champ   = np.append(champ,0)
	if bool(res[0][2]) :
	    if float(res[0][2]) not in longueur :
		longueur = np.append(longueur,float(res[0][2]))
        else :
            if LX not in longueur :
		longueur = np.append(longueur,LX)

##################################  :no
### Déclaration fonctions ########
##################################
zeros=sp.ai_zeros(3)[1][0]
def p(h,chi,zeros):
    nominateur = np.power(sp.airy(abs(h)/chi+zeros)[0],2)
    denominateur = 2*integrate.quad(lambda x : np.power(sp.airy(abs(x)/chi+zeros)[0],2),0,np.inf)[0]
    return nominateur/denominateur


def calcul_moment(x,y):
    moment=[0,0,0]
    x_bin=abs(x[1]-x[0])
    x_bin=1.0
    moment[0] = np.sum(y)*x_bin
    for index, valeur in np.ndenumerate(y):
        index=index[0]
        moment[1]+= x[index]*valeur*x_bin
    moment[1] /= moment[0]
    for index, valeur in np.ndenumerate(y):
        index=index[0]
        moment[2]+=np.power(x[index]-moment[1],2)*valeur
    moment[2] = np.power(moment[2]*x_bin/moment[0],0.5)
    return moment


def translation(nb,m):
    return 1.*nb*m/(m-1)-1.*m/2

def transfert(kbt,champ,inter,l):
    d=np.zeros((l,l))
    for y1,i in enumerate(d):
        for y2,j in enumerate(i):
            d[y1][y2] = np.exp(-kbt*champ*abs(translation(y1,l))/2 
                    -kbt*champ*abs(translation(y2,l))/2 
                    -kbt*inter*abs(translation(y1,l)-translation(y2,l)))
    return d

def fit_gauss(x,a,chi):
    return a*np.exp(-x**2/chi)

############################
# Moyenne des données
############################
big_data = {}

for file in sorted(os.listdir(directory)):
    if re.search(r"histo",file) != None :
        res = re.findall(regex_chain,file)	

        t=float(res[0][0]); l=longueur[0]; h=0
        if bool(res[0][1]):
            h=float(res[0][1])
        if bool(res[0][2]):
            l=float(res[0][2])
        try:
            data=np.loadtxt(directory+file)
            big_data[t,h,l] = data
        except: 
            continue
    else : 
        continue

def fit_exp(x,n,a):
    return a*np.exp(x/n)

###############################
# Accord TM et SOS
###############################
print temp,champ

for j,t in enumerate(sorted(temp)) :
    BETA = 1/(t*TC)
    for k,h in enumerate(champ):
       # if h < 0.1 or t < 11: 
       #     continue

        ########## Données Chipping #########
        courbe = [0,0]
        for i,lon in enumerate(longueur) :
            y=[];num=[];
            try : 
                for point in big_data[t,h,lon]:
                    if point[1] > 0 :
                       y=np.append(y,point[0]); num=np.append(num,point[1])
            except:
                continue
            moments = calcul_moment(y,num)
            print "Moments",t,h,moments
            y = (y-moments[1])/moments[2]; num  = np.multiply(num, moments[2]/moments[0])
            plt.plot(y,num,'-', label="T ="+str(t),color=colors[j%nb_color])

#            num = np.multiply(num,1/moments[0])
#
#            ym = y[np.where(y < 0)]
#            numm = num[np.where(y < 0)]
#            yp = y[np.where(y > 0)]
#            nump = num[np.where(y > 0)]
#
#
#            plt.plot(-ym,numm,'-.', label="Moins "+str(t),color=colors[j%nb_color])
#            plt.plot(yp,nump,'-', label="Plus",           color=colors[j%nb_color])

#            nump = nump[0:min(np.size(nump),np.size(numm))]
#            numm = numm[::-1][0:min(np.size(nump),np.size(numm))]
#            ym = ym[0:min(np.size(nump),np.size(numm))]
#            yp = yp[0:min(np.size(nump),np.size(numm))]
#            plt.plot(yp,np.divide(nump,numm),'-',label=str(t),color=colors[j%nb_color])

#            xfit = y[np.where(  (y >= 2))]
#            yfit = num[np.where((y >= 2))]
#            popt,pcov = curve_fit(fit_exp,xfit,yfit,p0=[-1,1])
#            plt.plot(xfit,fit_exp(xfit,popt[0],popt[1]),'+',label="T ="+str(t)+" , fit",color=colors[j%nb_color])
#            print t,popt[0],moments[2]
   

        ######### Matrice de transfert ############

        ########## Airy ############
        xhi = curve_fit(p,y,num,p0=[1,zeros])[0][0]  
        yairy = np.arange(-lon,lon+1,1)
        airy = p(yairy,xhi,zeros)
        moments = calcul_moment(yairy, airy)
        yairy = (yairy-moments[1])/moments[2]; airy  = np.multiply(airy, moments[2]/moments[0])
        plt.plot(yairy, airy,':',label="Airy ",color=colors[j%nb_color])
#
#        popt = curve_fit(fit_gauss,y,num,p0=[1,1])[0]
#        ygauss = np.arange(-lon,lon+1,1)
#        gauss = fit_gauss(ygauss,popt[0],popt[1])
#        moments = calcul_moment(ygauss, gauss)
#        ygauss = (ygauss-moments[1])/moments[2]; airy  = np.multiply(airy, moments[2]/moments[0])
#        plt.plot(ygauss, gauss,'.',label="Gauss ",color=colors[j%nb_color])


lon = 400
w, v    = linalg.eigh(transfert(1/(20*TC),0.2,J,2*lon+1))
ytm   = np.arange(-lon,lon+1,1)
tm  = np.power(v[:,np.argmax(w)],2)
moments = calcul_moment(ytm, tm)
ytm = (ytm-moments[1])/moments[2]; tm  = np.multiply(tm, moments[2]/moments[0])
plt.plot(ytm, tm,'-.',label="TM ")

#plt.axis([-6,6,2e-05,8e-01])
plt.ylabel('Height distribution')
plt.xlabel('Interface height)')
plt.yscale('log')
#plt.xlim([-10,10])
#plt.xscale('log')
plt.legend()
plt.savefig(directory+'kaw-ising.pdf')
plt.show()
plt.close()

