# -*- coding: utf-8 -*-
"""
Created on Mon Mar 10 13:17:49 2014

@author: cliu
"""
from numpy import *
from matplotlib.pyplot import *

AO2=array([5.80871,3.20291,4.17887,5.10006,-0.098664,3.80369])
BO2=array([-0.007016,-0.0077,-0.01386,-0.009515])
C0=-2.76E-07
AAr=array([2.79163,3.17714,4.13658,4.86632,0,0])
BAr=array([-0.00696317,-0.00768387,-0.00119078,0])

S=35.
temp=arange(5.,26)
i=0
CsO2=zeros_like(arange(5.,26))
CsAr=zeros_like(arange(5.,26))
for t in temp:
	Ts=log((298.15-t)/(273.15+t))
	CsO2[i]=exp(sum(AO2*array([1,Ts,Ts**2,Ts**3,Ts**4,Ts**5]))+sum(S*BO2*array([1,Ts,Ts**2,Ts**3]))+C0*S**2)
	CsAr[i]=exp(sum(AAr*array([1,Ts,Ts**2,Ts**3,Ts**4,Ts**5]))+sum(S*BAr*array([1,Ts,Ts**2,Ts**3])))
	i+=1

subplot(2,1,1)
plot(temp,CsO2,'bo-',label="O$_2$ conc.")
legend() 
ylabel('Conc. ($\mu$mol/kg)')

subplot(2,1,2)
plot(temp,CsAr,'ro-',label="Ar conc.")
legend()
xlabel('Temperature ($^O$C)')
ylabel('Conc. ($\mu$mol/kg)')
savefig('1.pdf', bbox_inches='tight')

figure()
plot(temp,CsO2/CsAr,'o-')
title('O$_2$/Ar ratio vs Temperature')
xlabel('Temperature ($^O$C)')
savefig('2.pdf', bbox_inches='tight')
