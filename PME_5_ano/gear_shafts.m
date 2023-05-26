%% Cálculo das forças de engrenamento

clc;
clear all;
close all;

gear_defenition;

% Forças de engrenamento para o par Z1 e Z2 em N; a função v_veio serve
% para converter a a velocidade do veio de rpm para m/s

% Assume-se que existem forças axiais e escolheu-se rolamentos angulares de
% esferas como hipótese inicial.

idx = 1;

v_veio(idx) = 2*pi*(pinhao(idx).diametro_primitivo*0.001/2)*w_entrada/60;

M_torsor(idx) = torque_motor;

Ft(idx) = M_torsor(idx)/((pinhao(idx).diametro_primitivo*0.001)/2); %momento aplicado é o torque do motor
Fr(idx) = Ft(idx)*(tan(alpha)/cos(beta(idx)));
Fx(idx) = Ft(idx)*tan(beta(idx));
Mz_pinhao(idx) = Fx(idx)*(pinhao(idx).diametro_primitivo*0.001/2);
Mz_roda(idx) = Fx(idx)*(roda(idx).diametro_primitivo*0.001/2);

Mf_XY(idx) = 235; %N.m
Mf_ZX(idx) = 155; %N.m
M_fletor(idx) = sqrt((Mf_ZX(idx)^2)+Mf_XY(idx)^2);
fs_veio(idx) = 1.5;
oy(idx) = 430000000; %Pa - aço Ck45 tempera + revenido

    % Critério de cedencia de Tresca

D(idx).tresca = (((32*fs_veio(idx))/(pi*oy(idx))*sqrt((M_fletor(idx)^2)+...
    M_torsor(idx)^2)))^(1/3); % m

D(idx).von_mises = (((32*fs_veio(idx))/(pi*oy(idx))*sqrt((M_fletor(idx)^2)+...
    0.75*M_torsor(idx)^2)))^(1/3); % m

R_a_xy(idx) = 103;
R_b_xy(idx) = 3862;

R_a_zy(idx) = -3920;
R_b_zy(idx) = 5880;

Fr_rolamento_a(idx) = sqrt((R_a_xy(idx)^2)+R_a_zy(idx)^2);
Fr_rolamento_b(idx) = sqrt((R_b_xy(idx)^2)+R_b_zy(idx)^2);

    % Para este caso, optou-se por rolamento de esferas contacto angular de
    % 40º para o primeiro apoio e cilindros cónicos com 15º de carreira simples
    % para o segundo.

alpha_contacto_rol(idx) = deg2rad(40);
alpha_contacto_rol_cilindro(idx) = deg2rad(15);

X0_a(idx) = 0.5;
Y0_a(idx) = 0.26;

X0_b(idx) = 0.5;
Y0_b(idx) = 0.22*cot(alpha_contacto_rol_cilindro(idx));

razao_forcas_rol_a(idx) = Fx(idx)/Fr_rolamento_a(idx);
razao_forcas_rol_b(idx) = Fx(idx)/Fr_rolamento_b(idx);

ceof_carga_axial(idx) = 1.14;
ceof_carga_axial_cilindro(idx)= 1.5*tan(alpha_contacto_rol_cilindro);

P0_axial_a(idx) = 2.3*Fr_rolamento_a(idx)*tan(alpha_contacto_rol(idx))...
    + Fx(idx);

if razao_forcas_rol_a(idx) > ceof_carga_axial(idx)
    X_a(idx) = 0.35;
    Y_a(idx) = 0.57;
else
    X_a(idx) = 1.0;
    Y_a(idx) = 0;
end

if razao_forcas_rol_b(idx) > ceof_carga_axial_cilindro(idx)
    X_b(idx) = 0.4;
    Y_b(idx) = 0.4*cot(alpha_contacto_rol);
else
    X_b(idx) = 1.0;
    Y_b(idx) = 0;
end

fs(idx) = 1.2; % coefeciente de segurança - normal
ft(idx) = 1.0; % fator de temperatura - <120º
fl(idx) = 2; % fator de esforço dinâmico - acionamento motores
fn(idx) = 0.322; % fator de rotação - 1500 rpm

P0_a(idx) = X0_a(idx)*Fr_rolamento_a(idx) + Y0_a(idx)*Fx(idx);
C0_a(idx) = fs(idx)*P0_a(idx);

P0_b(idx) = X0_b(idx)*Fr_rolamento_b(idx) + Y0_b(idx)*Fx(idx);
C0_b(idx) = fs(idx)*P0_b(idx);

P_a(idx) = X_a(idx)*Fr_rolamento_a(idx) + Y_a(idx)*Fx(idx);
C_a(idx) = (fl(idx)/(fn(idx)*ft(idx)))*P_a(idx);

P_b(idx) = X_b(idx)*Fr_rolamento_b(idx) + Y_b(idx)*Fx(idx);
C_b(idx) = (fl(idx)/(fn(idx)*ft(idx)))*P_b(idx);

    % Dimensionamento de chaveta

D_veio(idx) = 0.035; % 30<d<38

t_corte(idx) = 85000000; % MPa
t_esmagamento(idx) = 80000000;

b_chaveta(idx) = 10;
h_chaveta(idx) = 8;
t1_chaveta(idx) = 5;
t2_chaveta(idx) = 3.3;

L_min_t_corte(idx) = (2*M_torsor(idx))/(t_corte(idx)*b_chaveta(idx)*...
    D_veio(idx)); % m
L_min_t_esmagamento(idx) = (2*M_torsor(idx))/(t_esmagamento(idx)*...
    D_veio(idx)*(h_chaveta(idx)-t1_chaveta(idx))); % m

L_escolhida_pinhao(idx) = 0.025; % m

% Forças de engrenamento para o par Z3 e Z4 em N

idx = 2;

v_veio(idx) = 2*pi*(pinhao(idx).diametro_primitivo*0.001/2)...
    *pinhao(idx).rotacao/60;

M_torsor(idx) = P_motor_catalogo/v_veio(idx);

Ft(idx) = M_torsor(idx)/((pinhao(idx).diametro_primitivo*0.001)/2);
Fr(idx) = Ft(idx)*(tan(alpha)/cos(beta(idx)));
Fx(idx) = Ft(idx)*tan(beta(idx));
Mz_pinhao(idx) = Fx(idx)*(pinhao(idx).diametro_primitivo*0.001/2);
Mz_roda(idx) = Fx(idx)*(roda(idx).diametro_primitivo*0.001/2);

Mf_XY(idx) = 235; %N.m
Mf_ZX(idx) = 645; %N.m
M_fletor(idx) = sqrt((Mf_ZX(idx)^2)+Mf_XY(idx)^2);
fs_veio(idx) = 1.5;
oy(idx) = 430000000; %Pa - aço Ck45 tempera + revenido

    % Critério de cedencia de Tresca

D(idx).tresca = (((32*fs_veio(idx))/(pi*oy(idx))*sqrt((M_fletor(idx)^2)+...
    M_torsor(idx)^2)))^(1/3); % m

D(idx).von_mises = (((32*fs_veio(idx))/(pi*oy(idx))*sqrt((M_fletor(idx)^2)+...
    0.75*M_torsor(idx)^2)))^(1/3); % m

R_a_xy(idx) = 747;
R_b_xy(idx) = 3447;

R_a_zy(idx) = 3920;
R_b_zy(idx) = 8820;

Fr_rolamento_a(idx) = sqrt((R_a_xy(idx)^2)+R_a_zy(idx)^2);
Fr_rolamento_b(idx) = sqrt((R_b_xy(idx)^2)+R_b_zy(idx)^2);

    % Para este caso, optou-se por rolamentos de carreira simples com
    % contacto angular de 40º e cilindros cónicos com contacto angular de
    % 15º

alpha_contacto_rol(idx) = deg2rad(40);
alpha_contacto_rol_cilindro(idx) = deg2rad(15);

X0_a(idx) = 0.5;
Y0_a(idx) = 0.26;

X0_b(idx) = 0.5;
Y0_b(idx) = 0.22*cot(alpha_contacto_rol_cilindro(idx));

razao_forcas_rol_a(idx) = Fx(idx)/Fr_rolamento_a(idx);
razao_forcas_rol_b(idx) = Fx(idx)/Fr_rolamento_b(idx);

ceof_carga_axial(idx) = 1.14;
ceof_carga_axial_cilindro(idx) = 1.5*tan(alpha_contacto_rol_cilindro(idx));

P0_axial_a(idx) = 2.3*Fr_rolamento_a(idx)*tan(alpha_contacto_rol(idx))...
    + Fx(idx)-Fx(idx-1);
P0_axial_b(idx) = 2.3*Fr_rolamento_b(idx)*tan(alpha_contacto_rol(idx))...
    + Fx(idx)-Fx(idx-1);

if razao_forcas_rol_a(idx) > ceof_carga_axial(idx)
    X_a(idx) = 0.35;
    Y_a(idx) = 0.57;
else
    X_a(idx) = 1.0;
    Y_a(idx) = 0;
end

if razao_forcas_rol_b(idx) > ceof_carga_axial_cilindro(idx)
    X_b(idx) = 0.4;
    Y_b(idx) = 0.4*cot(alpha_contacto_rol_cilindro(idx));
else
    X_b(idx) = 1.0;
    Y_b(idx) = 0;
end

fs(idx) = 1.2; % coefeciente de segurança - normal
ft(idx) = 1.0; % fator de temperatura - <120º
fl(idx) = 2; % fator de esforço dinâmico - acionamento de motores
fn(idx) = 0.405; % fator de rotação - 500 rpm

P0_a(idx) = X0_a(idx)*Fr_rolamento_a(idx) + Y0_a(idx)*(Fx(idx)-Fx(idx-1));
C0_a(idx) = fs(idx)*P0_a(idx);

P0_b(idx) = X0_b(idx)*Fr_rolamento_b(idx) + Y0_b(idx)*(Fx(idx)-Fx(idx-1));
C0_b(idx) = fs(idx)*P0_b(idx);

P_a(idx) = X_a(idx)*Fr_rolamento_a(idx) + Y_a(idx)*(Fx(idx)-Fx(idx-1));
C_a(idx) = (fl(idx)/(fn(idx)*ft(idx)))*P_a(idx);

P_b(idx) = X_b(idx)*Fr_rolamento_b(idx) + Y_b(idx)*(Fx(idx)-Fx(idx-1));
C_b(idx) = (fl(idx)/(fn(idx)*ft(idx)))*P_b(idx);

    % Dimensionamento de chaveta

D_veio(idx) = 0.025; % 30<d<38

t_corte(idx) = 85000000; % MPa
t_esmagamento(idx) = 80000000;

b_chaveta(idx) = 8;
h_chaveta(idx) = 7;
t1_chaveta(idx) = 4;
t2_chaveta(idx) = 3.3;

L_min_t_corte(idx) = (2*M_torsor(idx))/(t_corte(idx)*b_chaveta(idx)*...
    D_veio(idx)); % m
L_min_t_esmagamento(idx) = (2*M_torsor(idx))/(t_esmagamento(idx)*...
    D_veio(idx)*(h_chaveta(idx)-t1_chaveta(idx))); % m

L_escolhida_roda(idx) = 0.025; % m
L_escolhida_pinhao(idx) = 0.045; % m

% Forças de engrenamento para o par Z5 e Z6 em N

idx = 3;

v_veio(idx) = 2*pi*(pinhao(idx).diametro_primitivo*0.001/2)*pinhao(idx).rotacao/60;

M_torsor(idx) = P_motor_catalogo/v_veio(idx);

Ft(idx) = M_torsor(idx)/((pinhao(idx).diametro_primitivo*0.001)/2);
Fr(idx) = Ft(idx)*(tan(alpha)/cos(beta(idx)));
Fx(idx) = Ft(idx)*tan(beta(idx));
Mz_pinhao(idx) = Fx(idx)*(pinhao(idx).diametro_primitivo*0.001/2);
Mz_roda(idx) = Fx(idx)*(roda(idx).diametro_primitivo*0.001/2);

Mf_XY(idx) = 361; % N.m
Mf_ZX(idx) = 2111; %N.m
M_fletor(idx) = sqrt((Mf_ZX(idx)^2)+Mf_XY(idx)^2);
fs_veio(idx) = 1.5;
oy(idx) = 750000000; %Pa - aço 42CrMo4 tempera + revenido

    % Critério de cedencia de Tresca

D(idx).tresca = (((32*fs_veio(idx))/(pi*oy(idx))*sqrt((M_fletor(idx)^2)+...
    M_torsor(idx)^2)))^(1/3); % m

D(idx).von_mises = (((32*fs_veio(idx))/(pi*oy(idx))*sqrt((M_fletor(idx)^2)+...
    0.75*M_torsor(idx)^2)))^(1/3); % m

R_a_xy(idx) = -7115;
R_b_xy(idx) = -5671;

R_a_zy(idx) = -3762;
R_b_zy(idx) = -626;

Fr_rolamento_a(idx) = sqrt((R_a_xy(idx)^2)+R_a_zy(idx)^2);
Fr_rolamento_b(idx) = sqrt((R_b_xy(idx)^2)+R_b_zy(idx)^2);

    % Para este caso, optou-se por rolamentos de carreira simples com
    % contacto angular de 40º e cilindros cónicos com contacto angular de
    % 15º

alpha_contacto_rol(idx) = deg2rad(40);
alpha_contacto_rol_cilindro(idx) = deg2rad(15);

X0_a(idx) = 0.5;
Y0_a(idx) = 0.26;

X0_b(idx) = 0.05;
Y0_b(idx) = 0.22*cot(alpha_contacto_rol_cilindro(idx));

razao_forcas_rol_a(idx) = Fx(idx)/Fr_rolamento_a(idx);
razao_forcas_rol_b(idx) = Fx(idx)/Fr_rolamento_b(idx);

ceof_carga_axial(idx) = 1.14;
ceof_carga_axial_cilindro(idx) = 1.5*tan(alpha_contacto_rol_cilindro(idx));

P0_axial_a(idx) = 2.3*Fr_rolamento_a(idx)*tan(alpha_contacto_rol(idx))...
    + Fx(idx)-Fx(idx-1);

if razao_forcas_rol_a(idx) > ceof_carga_axial(idx)
    X_a(idx) = 0.35;
    Y_a(idx) = 0.57;
else
    X_a(idx) = 1.0;
    Y_a(idx) = 0;
end

if razao_forcas_rol_b(idx) > ceof_carga_axial_cilindro(idx)
    X_b(idx) = 0.4;
    Y_b(idx) = 0.4*cot(alpha_contacto_rol_cilindro(idx));
else
    X_b(idx) = 1.0;
    Y_b(idx) = 0;
end

fs(idx) = 1.2; % coefeciente de segurança - normal
ft(idx) = 1.0; % fator de temperatura - <120º
fl(idx) = 2; % fator de esforço dinâmico - acionamento de motores
fn(idx) = 0.693; % fator de rotação - 100 rpm

P0_a(idx) = X0_a(idx)*Fr_rolamento_a(idx) + Y0_a(idx)*(Fx(idx)-Fx(idx-1));
C0_a(idx) = fs(idx)*P0_a(idx);

P0_b(idx) = X0_b(idx)*Fr_rolamento_b(idx) + Y0_b(idx)*(Fx(idx)-Fx(idx-1));
C0_b(idx) = fs(idx)*P0_b(idx);

P_a(idx) = X_a(idx)*Fr_rolamento_a(idx) + Y_a(idx)*(Fx(idx)-Fx(idx-1));
C_a(idx) = (fl(idx)/(fn(idx)*ft(idx)))*P_a(idx);

P_b(idx) = X_b(idx)*Fr_rolamento_b(idx) + Y_b(idx)*(Fx(idx)-Fx(idx-1));
C_b(idx) = (fl(idx)/(fn(idx)*ft(idx)))*P_b(idx);

    % Dimensionamento de chaveta

D_veio(idx) = 0.025; % 30<d<38

t_corte(idx) = 85000000; % MPa
t_esmagamento(idx) = 80000000;

b_chaveta(idx) = 8;
h_chaveta(idx) = 7;
t1_chaveta(idx) = 4;
t2_chaveta(idx) = 3.3;

L_min_t_corte(idx) = (2*M_torsor(idx))/(t_corte(idx)*b_chaveta(idx)*...
    D_veio(idx)); % m
L_min_t_esmagamento(idx) = (2*M_torsor(idx))/(t_esmagamento(idx)*...
    D_veio(idx)*(h_chaveta(idx)-t1_chaveta(idx))); % m

L_escolhida_roda(idx) = 0.045; % m
L_escolhida_pinhao(idx) = 0.025; % m


%Ultimo veio

idx = 4;

v_veio(idx) = 2*pi*(roda(idx-1).diametro_primitivo*0.001/2)*pinhao(idx-1).rotacao...
    /u(3)/60;
M_torsor(idx) = P_motor_catalogo/v_veio(idx);

Mf_XY(idx) = 386; % N.m
Mf_ZX(idx) = 2510; %N.m
M_fletor(idx) = sqrt((Mf_ZX(idx)^2)+Mf_XY(idx)^2);
fs_veio(idx) = 1.5;
oy(idx) = 750000000; %Pa - aço 42CrMo4 tempera + revenido

    % Critério de cedencia de Tresca

D(idx).tresca = (((32*fs_veio(idx))/(pi*oy(idx))*sqrt((M_fletor(idx)^2)+...
    M_torsor(idx)^2)))^(1/3); % m

D(idx).von_mises = (((32*fs_veio(idx))/(pi*oy(idx))*sqrt((M_fletor(idx)^2)+...
    0.75*M_torsor(idx)^2)))^(1/3); % m


R_a_xy(idx) = -25100;
R_b_xy(idx) = -33000;

R_a_zy(idx) = 3858;
R_b_zy(idx) = -12862;

Fr_rolamento_a(idx) = sqrt((R_a_xy(idx)^2)+R_a_zy(idx)^2);
Fr_rolamento_b(idx) = sqrt((R_b_xy(idx)^2)+R_b_zy(idx)^2);

 % Para este caso, optou-se por rolamentos de carreira simples com
    % contacto angular de 40º para ambos os casos

alpha_contacto_rol(idx) = deg2rad(40);

X0_a(idx) = 0.5;
Y0_a(idx) = 0.26;

X0_b(idx) = 0.5;
Y0_b(idx) = 0.26;

razao_forcas_rol_a(idx) = Fx(idx-1)/Fr_rolamento_a(idx);
razao_forcas_rol_b(idx) = Fx(idx-1)/Fr_rolamento_b(idx);

ceof_carga_axial(idx) = 1.14;

P0_axial_a(idx) = 2.3*Fr_rolamento_a(idx)*tan(alpha_contacto_rol(idx))...
    + Fx(idx-1);

if razao_forcas_rol_a(idx) > ceof_carga_axial(idx)
    X_a(idx) = 0.35;
    Y_a(idx) = 0.57;
else
    X_a(idx) = 1.0;
    Y_a(idx) = 0;
end

if razao_forcas_rol_b(idx) > ceof_carga_axial(idx)
    X_b(idx) = 0.35;
    Y_b(idx) = 0.57;
else
    X_b(idx) = 1.0;
    Y_b(idx) = 0;
end

fs(idx) = 1.2; % coefeciente de segurança - normal
ft(idx) = 1.0; % fator de temperatura - <120º
fl(idx) = 1.5; % fator de esforço dinâmico - acionamento motores
fn(idx) = 0.693; % fator de rotação - 1500 rpm

P0_a(idx) = X0_a(idx)*Fr_rolamento_a(idx) + Y0_a(idx)*Fx(idx-1);
C0_a(idx) = fs(idx)*P0_a(idx);

P0_b(idx) = X0_b(idx)*Fr_rolamento_b(idx) + Y0_b(idx)*Fx(idx-1);
C0_b(idx) = fs(idx)*P0_b(idx);

P_a(idx) = X_a(idx)*Fr_rolamento_a(idx) + Y_a(idx)*Fx(idx-1);
C_a(idx) = (fl(idx)/(fn(idx)*ft(idx)))*P_a(idx);

P_b(idx) = X_b(idx)*Fr_rolamento_b(idx) + Y_b(idx)*Fx(idx-1);
C_b(idx) = (fl(idx)/(fn(idx)*ft(idx)))*P_b(idx);

    % Dimensionamento de chaveta

D_veio(idx) = 0.055; % 30<d<38

t_corte(idx) = 85000000; % MPa
t_esmagamento(idx) = 80000000;

b_chaveta(idx) = 16;
h_chaveta(idx) = 10;
t1_chaveta(idx) = 6;
t2_chaveta(idx) = 4.3;

L_min_t_corte(idx) = (2*M_torsor(idx))/(t_corte(idx)*b_chaveta(idx)*...
    D_veio(idx));
L_min_t_esmagamento(idx) = (2*M_torsor(idx))/(t_esmagamento(idx)*...
    D_veio(idx)*(h_chaveta(idx)-t1_chaveta(idx)));

L_escolhida_roda(idx) = 0.025; % m


