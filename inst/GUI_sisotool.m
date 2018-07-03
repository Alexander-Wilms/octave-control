## 16.06.2016 Erivelton Gualter dos Santos <erivelton.gualter@gmail.com>
## sisotool

## Author: Erivelton Gualter dos Santos <erivelton.gualter@gmail.com>

graphics_toolkit qt

## Delete it later (Only for debug) -------------------------------------------------------------------------------
close all 
clear all
clc
## -------------------------------------------------------------------------------------------------------------------------------

## For now, I am using global variables. It will be modified
global h1 h2

% Initizailiation of the variables
h1.H = 1;   # Sensor
##h1.C = zpk([],[],1);  # Compensator
Kp = 300; Kd = 10;
h1.C = pid(Kp,0,Kd)

% Initial Plant (Only for test)
##h1.G = tf([2 5 1],[1 2 3]);
##h1.G = zpk([], -30, 100);
s = tf('s');
h1.G = 1/(s^2 + 10*s + 20);

% Creating Figures (Main GUI and Diagrams) 
fig2 = figure;
h2.axrl    = subplot(2,2,[1 3]); % Root Locus Axes
h2.axbm = subplot(2,2,2);       % Bode Margin Axes
h2.axbp  = subplot(2,2,4);       % Bode Phase Axes
h2.axny  = subplot(2,2,2);       % Nyquist Axes
set(fig2, 'Name','Diagrams','NumberTitle','off');
##position = get (fig2, "position");
##set (fig2, "position", position + [-50 -50 +250 +250]) ;

fig1 = figure;
h1.ax1 = axes ("position", [0.05 0.5 0.9 0.5]);
set (fig1, 'Name','sisotool- Control System Designer v0','NumberTitle','off');


## MENUS

# Fig1 
view_menu1 = uimenu (fig1, 'label', '&View');

uimenu (view_menu1, 'label', 'Root Locus',       'accelerator', 'r', 'callback', 'call_view_rootlocus');
uimenu (view_menu1, 'label', 'Bode Diagram', 'accelerator', 'b', 'callback', 'call_view_bode');
uimenu (view_menu1, 'label', 'Nyquist',            'accelerator', 'n', 'callback', 'call_view_nyquist');

add_menu1 = uimenu (fig1, 'label', '&Add');
uimenu (add_menu1, 'label', "'x' Real Pole",           'callback', 'call_add_poles');
uimenu (add_menu1, 'label',  "'xx' Complex Pole", 'callback', 'call_add_cpoles');
uimenu (add_menu1, 'label',  "'o' Real Zero",          'callback', 'call_add_zeros');
uimenu (add_menu1, 'label',  "'oo' Complex Zero", 'callback', 'call_add_czeros');
uimenu (add_menu1, 'label', "Integrator",               'callback', 'call_pendig');
uimenu (add_menu1, 'label', "Differentiator",          'callback', 'call_pendig');
uimenu (add_menu1, 'label',  "Lead",                      'callback', 'call_pendig');
uimenu (add_menu1, 'label', "Lag",                         'callback', 'call_pendig');
uimenu (add_menu1, 'label', "Notch",                     'callback', 'call_pendig');
                                
controller_menu1 = uimenu(fig1, 'label', '&Controller');
uimenu(controller_menu1, 'label', 'Save', 'callback', 'call_save_controlller');


# Fig2
view_menu2 = uimenu (fig2, 'label', '&View');

uimenu (view_menu2, 'label', 'Root Locus',       'accelerator', 'r', 'callback', 'call_view_rootlocus');
uimenu (view_menu2, 'label', 'Bode Diagram', 'accelerator', 'b', 'callback', 'call_view_bode');
uimenu (view_menu2, 'label', 'Nyquist',            'accelerator', 'n', 'callback', 'call_view_nyquist');

add_menu2 = uimenu (fig2, 'label', '&Add');
uimenu (add_menu2, 'label', "'x' Real Pole",           'callback', 'call_add_poles');
uimenu (add_menu2, 'label',  "'xx' Complex Pole", 'callback', 'call_add_cpoles');
uimenu (add_menu2, 'label',  "'o' Real Zero",          'callback', 'call_add_zeros');
uimenu (add_menu2, 'label',  "'oo' Complex Zero", 'callback', 'call_add_czeros');
uimenu (add_menu2, 'label', "Integrator",               'callback', 'call_pendig');
uimenu (add_menu2, 'label', "Differentiator",          'callback', 'call_pendig');
uimenu (add_menu2, 'label',  "Lead",                      'callback', 'call_pendig');
uimenu (add_menu2, 'label', "Lag",                         'callback', 'call_pendig');
uimenu (add_menu2, 'label', "Notch",                     'callback', 'call_pendig');
                                
controller_menu2 = uimenu(fig2, 'label', '&Controller');
uimenu(controller_menu2, 'label', 'Save', 'callback', 'call_save_controlller');

# 
c = uicontextmenu (fig2);

% create menus in the context menu
h2.m1 = uimenu ("parent",c,"label","Edit Compensantor ... ","callback",'call_menuedit');

% set the context menu for the figure
set (fig2, "uicontextmenu", c);

%%%%%%%

function update_plot (init)
  disp('DEG: update_plot');
    global h1 h2

    if (init == 1)
      set (h1.radio_bode, "value", 1);
      set (h1.radio_locus, "value", 1);
    endif
    ## Create subplots accoring to the radio buttons (Root Locus, Bode, and Nyquist)
    diag = [get(h1.radio_locus, 'Value') get(h1.radio_bode, 'Value') get(h1.radio_nyquist, 'Value')];
    set(0, 'currentfigure', 1); 
    switch (diag)
      case {[ 1 0 0]}
        h2.axrl    = subplot(2,2,[1 2 3 4]); 
      case {[ 0 1 0]}
        h2.axbm = subplot(2,2,[1 2]);
        h2.axbp  = subplot(2,2,[3 4]); 
      case {[ 0 0 1]}
        h2.axny   = subplot(2,2,[1 2 3 4]);
   
      case {[ 0 1 1]}
        h2.axny  = subplot(2,2,[1 3]); 
        h2.axbm = subplot(2,2,2);
        h2.axbp  = subplot(2,2,4);
      case {[ 1 0 1]}
        h2.axrl    = subplot(2,1,1); 
        h2.axny  = subplot(2,1,2); 
      case {[ 1 1 0]}
        h2.axrl    = subplot(2,2,[1 3]);
        h2.axbm = subplot(2,2,2); 
        h2.axbp  = subplot(2,2,4);
        
      case {[ 1 1 1]}
        h2.axrl    = subplot(2,2,1);
        h2.axrl    = subplot(2,2,1);
        h2.axny  = subplot(2,2,3);
        h2.axbm = subplot(2,2,2);
        h2.axbp  = subplot(2,2,4);
    endswitch
        
    ## Plot diagrams if any of the radio buttons is pressed 
    if (get(h1.radio_locus, 'Value') || get(h1.radio_bode, 'Value') || get(h1.radio_nyquist, 'Value') || init)
      if (isaxes(h2.axrl) == 1)   
        axes(h2.axrl);
        plotrlocus();
##        e = eig(h1.G);
##        ec = eig(h1.C*h1.G/(h1.H+h1.C*h1.G));
##        eigencl = ec(~any(abs(bsxfun(@minus, ec(:).', e(:))) < 1e-6, 1));
##        hold on; plot(eigencl,"*", "color", "m", "markersize", 8, "linewidth", 6);
##        hold off;
      endif
      if (isaxes(h2.axny) == 1)
        axes(h2.axny);
        nyquist(h1.G);
      endif
      if (isaxes(h2.axbm) == 1)
        axes(h2.axbm);
        plotbode();   
      endif
    endif
        
    switch (gcbo)
      case {h1.radio_dragging}
        set (h1.radio_add, "value", 0);
        set(h1.radio_delete, "value", 0);
      case {h1.radio_add}
        set (h1.radio_dragging, "value", 0);
        set(h1.radio_delete, "value", 0);
      case{h1.radio_delete }
        set (h1.radio_add, "value", 0);
        set (h1.radio_dragging, "value", 0);
      case {h1.btn_savecontroller}
        C = h1.C;
        save controller.mat C;
      case {h1.enter_plant}
        s = tf('s');
        v = get (gcbo, "string");
        
        ## Try-catch for plant input
        try
          h1.G = eval(v);
          h1.C = zpk([],[],1); 

          set(h1.lbl_plant, 'String', 'Transfer function : ... valid ! ...');

          if (isaxes(h2.axrl) == 1)
            axes(h2.axrl);
            plotrlocus();
          endif
          if (isaxes(h2.axny) == 1)
            axes(h2.axny);
            nyquist(h1.G);
          endif
          if (isaxes(h2.axbm) == 1)
            axes(h2.axbm);
            plotbode();
          endif
            axes(h1.ax1);
            step(feedback(h1.C*h1.G)); 
            axes(h2.axrl);
        catch
          set(h1.lbl_plant, 'String', 'Transfer function : ... invalid! Try again  ...');
        end_try_catch

    endswitch

##    ## Initial Plot (IT WILL BE CHANGED)
##    if (init == 1)
##      disp('TRUE')
##      axes(h1.ax1);
##      step(feedback(h1.C*h1.G)); 
##      
##      axes(h2.axrl);
##      plotrlocus()
##
##      axes(h2.axbm);
##      plotbode();
##      
##      set (h1.radio_bode, "value", 1);
##      set (h1.radio_locus, "value", 1);
##      
##    endif
    
##    plotrlocus();
endfunction

function down_fig(hsrc, evt)
  disp('DEG: down_fig');
  global h1 h2
  plotcleig = 0;
  
  axes(h2.axrl);
  c = get (gca, "currentpoint")([1;3]);   %% Current position of the mouse
  
  ## Plot black circle around the closest pole or zero.
  if ( get(h1.radio_dragging, "value") || get(h1.radio_delete, "value")) 
        [olpol, olzer, ~,~] = getZP (h1.C);
        poles(1,:) = [real(olpol)' real(olzer)'];
        poles(2,:) = [imag(olpol)' imag(olzer)'];

        p = poles - c;
        [~, idx] = min (hypot (p(1, :), p(2, :)));
                
        hold on
        for i=1:length(poles)
          if idx == i
            plot (poles(1, idx), poles(2, idx), "o", "markersize", 15, "color", "black", "linewidth", 2); 
          else
            plot (poles(1, i), poles(2, i), "o", "markersize", 15, "color", "white", "linewidth", 2); 
          endif  
        endfor
        hold off    
  endif
    
  ## ADDING action
  if (gca == h2.axrl && get(h1.radio_add, "value")) 
    disp('DEG: down_fig: ADDING');
    switch ( get (h1.editor_list, "Value") )   
      case {2} ## Add 'x' Real Pole
        plotcleig = 1;                  
        [olpol, olzer,k,~] = getZP (h1.C);
                
        olpol = [olpol; c(1)];
        h1.C = zpk (olzer, olpol',k);
        
        disp("add real pole")
        
      case {3} ##  Add 'xx' Complex Pole
        plotcleig = 1;
        [olpol, olzer,k,~] = getZP (h1.C);
                
        olpol = [olpol; c(1)+i*c(2); c(1)-i*c(2)];
        h1.C = zpk (olzer, olpol',k);
        
      case {4} ##  Add 'o' Real Zero
        plotcleig = 1;        
        [olpol, olzer,k,~] = getZP (h1.C);
                
        olzer = [olzer; c(1)];
        h1.C = zpk (olzer, olpol',k);
        
      case {5} ##  Add  'oo' Complex Zero
        plotcleig = 1;             
        [olpol, olzer,k,~] = getZP (h1.C);
                
        olzer = [olzer; c(1)+i*c(2); c(1)-i*c(2)];
        h1.C = zpk (olzer, olpol',k);
                
      case {6} ##  Add Integrator
      case {7} ##  Add Differentiator
      case {8} ##  Add Lead
      case {9} ##  Add Lag
      case {10} ##  Add Notch
    endswitch
       
    if (isaxes(h2.axny) == 1)
      axes(h2.axny);
      nyquist(h1.G);
    endif
      
    set (h1.editor_list, "Value", 1); %% Set none in the list
    set (h1.radio_add, "value", 0);

  endif

endfunction


function release_click (hsrc, evt)
## release_click (hsrc, evt)
##
## This function controls the action when the mouse is release.
## The action depends on the Roots Editor Action: ADJUST, DELETE OR DELETE
  disp('DEG: release_click');
  global h1 h2
  axes(h2.axrl); 
  c = get (gca, "currentpoint")([1;3]); 

  if ( get(h1.radio_delete, "value") ) ## DELETE
    disp('DEG: release_click: DELETE');
    h1.C
    [olpol, olzer,k,~] = getZP (h1.C);
    poles(1,:) = [real(olpol)' real(olzer)'];
    poles(2,:) = [imag(olpol)' imag(olzer)'];

    # find nearest point
    p = poles - c;
    [~, idx] = min (hypot (p(1, :), p(2, :)));
        
    if abs(poles(2, idx)) > 0
      idxc = find(poles(2,:) == -1*poles(2, idx), 1, 'last');      
      poles(:, idx) = [];
      poles(:, idxc) = [];
      lastpol = length(olpol);
      if idx <= length(olpol)
        olpol = poles(1, 1:lastpol-2) + poles(2, 1:lastpol-2)*i;
        olzer = poles(1, lastpol-1:end) + poles(2, lastpol-1:end)*i;
      else
        olpol = poles(1, 1:lastpol) + poles(2, 1:lastpol)*i;
        olzer = poles(1, lastpol+1:end) + poles(2, lastpol+1:end)*i;
      endif
    else
      poles(:,idx) = [];
      lastpol = length(olpol);
      if idx <= length(olpol)
        olpol = poles(1, 1:lastpol-1) + poles(2, 1:lastpol-1)*i;
        olzer = poles(1, lastpol:end) + poles(2, lastpol:end)*i;
      else
        olpol = poles(1, 1:lastpol) + poles(2, 1:lastpol)*i;
        olzer = poles(1, lastpol+1:end) + poles(2, lastpol+1:end)*i;
      endif
    endif
        
    h1.C = zpk (olzer, olpol',k);
   endif
   
  if ( get(h1.radio_dragging, "value") ) ## DRAGGING
    disp('DEG: release_click: DRAGGING');
    [olpol, olzer, k, ~] = getZP (h1.C);
    poles(1,:) = [real(olpol)' real(olzer)'];
    poles(2,:) = [imag(olpol)' imag(olzer)'];

    # find nearest point
    p = poles - c;
    [~, idx] = min (hypot (p(1, :), p(2, :)));
        
    if abs(poles(2, idx)) > 0
      idxc = find(poles(2,:) == -1*poles(2, idx), 1, 'last');      
      disp("imag")
      poles(:, idx) = [c(1); c(2)];
      poles(:, idxc) = [c(1); -c(2)];
    else
      poles(1,idx) = c(1);
      disp("real")
    endif
    
    olpol = poles(1, 1:length(olpol)) + poles(2, 1:length(olpol))*i;
    olzer = poles(1, length(olpol)+1:end) + poles(2, length(olpol)+1:end)*i;
        
    h1.C = zpk (olzer, olpol',k);

   endif
       
  plotrlocus();
  
endfunction

  
function [olpol, olzer, k, flag] = getZP (sys)
## [olpol, olzer, k, flag] = getZP (sys)
##
## Return the poles/zeros/gain and if the "sys". (based on rlocus.m)
## 
## Input:
##      sys: LTI system
##  Outputs:
##      olpol = 1 x number of poles = Array of Poles 
##      olzer = 1 x number of zeros = Array of zeros 
##      k = 1x1 = Gain
##      flag = '1' if sys is a LTI system, otherwise '0' 

  ## Convert the input to a transfer function if necessary
  [num, den] = tfdata (sys, "vector");     # extract numerator/denominator polynomials
  lnum = length (num);
  lden = length (den);
  
  ## equalize length of num, den polynomials
  ## TODO: handle case lnum > lden (non-proper models)
  if (lden < 2)
    ## error ("rlocus: system has no poles");
    flag = 0;
  elseif (lnum < lden)
    num = [zeros(1,lden-lnum), num];       # so that derivative is shortened by one
    flag = 1;
  endif

  olpol = roots (den);
  olzer = roots (num);
  [~,~,k] = zpkdata(sys);
endfunction

function slider_adjustgain(hsrc, evt)
  global h1 h2

  [z,p,k] = zpkdata(h1.C);
  k = get( h1.slider_gain, "value");
  
  h1.C = zpk(z,p,k);
  
  plotrlocus();
  
  if (isaxes(h2.axbm) == 1)
    axes(h2.axbm);
    plotbode();
  endif
   
endfunction

function plotrlocus()
  disp('DEG: plotrlocus');
  global h1 h2
  
  [olpol, olzer, ~] = getZP (h1.C);
  
  axes(h2.axrl); cla
  rlocus(h1.G*h1.C);
  if (!isempty (olpol))
    hold on; plot (real(olpol),  imag(olpol), "x", "markersize", 8, "color", "magent", "linewidth", 2);  hold off; 
  endif
  if (!isempty (olzer))
    hold on; plot (real(olzer), imag(olzer), "o", "markersize", 8, "color", "magent", "linewidth", 2); hold off;
  endif
  
  e = eig(h1.G);
  ec = eig(h1.C*h1.G/(h1.H+h1.C*h1.G));
  eigencl = ec(~any(abs(bsxfun(@minus, ec(:).', e(:))) < 1e-6, 1));
  X = real(eigencl);
  Y = imag(eigencl);
  hold on; plot(X,Y,"*", "color", "m", "markersize", 8, "linewidth", 6);
  hold off;
  xlim auto
   
  axes(h1.ax1);
  step(feedback(h1.C*h1.G)); 
  axes(h2.axrl);
endfunction

function plotbode()
  disp('DEG: plotbode');
  global h1 h2

  bode (h1.G, 'sisotool'); 
  [MAG, PHA, W] = bode (h1.G); 
  MAG = mag2db(MAG);

  [olpol, olzer, k,~] = getZP (h1.G);
  poles(1,:) = real(olpol)';
  poles(2,:) = imag(olpol)';

  zeros(1,:) = real(olzer)';
  zeros(2,:) = imag(olzer)';

  wparray = sqrt(poles(1,:).*poles(1,:) + poles(2,:).*poles(2,:));
  wzarray = sqrt(zeros(1,:).*zeros(1,:) + zeros(2,:).*zeros(2,:));

  if (length(wparray) > 0)
    for i=1:length(wparray)
      idxp(i) = find(W <= wparray(i), 1, 'last');      
    endfor
    axes(h2.axbm); hold on; plot(W(idxp), MAG(idxp), 'x', "color", "r", "markersize", 8, "linewidth", 4); hold off;
    axes(h2.axbp); hold on; plot(W(idxp), PHA(idxp), 'x', "color", "r","markersize", 8, "linewidth", 4); hold off;
  endif

  if (length(wzarray) > 0)
    for i=1:length(wzarray)
      idxz(i) = find(W <= wzarray(i), 1, 'last');      
    endfor
    axes(h2.axbm ); hold on; plot(W(idxz), MAG(idxz), 'o', "color", "g", "markersize", 8, "linewidth", 4);  hold off;
    axes(h2.axbp ); hold on; plot(W(idxz), PHA(idxz), 'o', "color", "g", "markersize", 8, "linewidth", 4); hold off;
  endif

  [Gm,Pm,Wgm,Wpm] = margin(h1.G) ;

  Gm = round(Gm*10)/10;
  Pm = round(Pm*10)/10;
  Wgm = round(Wgm*10)/10;
  Wpm = round(Wpm*10)/10;

  descrm = {strcat('G.M:  ',num2str(Gm)) ; 
  strcat('Freq:  ', num2str(Wgm))};

  descrp = {strcat('P.M:  ',num2str(Pm)) ; 
  strcat('Freq:  ', num2str(Wpm))};     

  axes(h2.axbm) ;  grid off
  xLim = get(gca,'XLim');  %# Get the range of the x axis
  yLim = get(gca,'YLim');  %# Get the range of the y axis
  text(min(xLim), median(yLim),descrm)

  axes(h2.axbp);  grid off  
  xLim = get(gca,'XLim');  %# Get the range of the x axis
  yLim = get(gca,'YLim');  %# Get the range of the y axis
  text(min(xLim), median(yLim),descrp);
endfunction


## Callbacks Menu 

## Menu tab to display Root Locus Diagram
function call_view_rootlocus (hsrc, evt)
  global h1 h2
  
  if (get(h1.radio_locus, 'Value'))
    set(h1.radio_locus, 'Value',0);
  else
    set(h1.radio_locus, 'Value',1);
  endif
  
  update_plot (false);
endfunction

## Menu tab to display Bode Diagram
function call_view_bode (hsrc, evt)
  global h1 h2
  
  if (get(h1.radio_bode, 'Value'))
    set(h1.radio_bode, 'Value',0);
  else
    set(h1.radio_bode, 'Value',1);
  endif
  
  update_plot (false);
endfunction

## Menu tab to display Nyquist Diagram
function call_view_nyquist (hsrc, evt)
  global h1 h2
  
  if (get(h1.radio_nyquist, 'Value'))
    set(h1.radio_nyquist, 'Value',0);
  else
    set(h1.radio_nyquist, 'Value',1);
  endif
  
  update_plot (false);
endfunction

## Menu tab to add poles
function call_add_poles(hsrc, evt) 
  global h1 h2
  set(h1.radio_add, 'Value', 1);
  set (h1.editor_list, "Value", 2);
endfunction

## Menu tab to add complex poles
function call_add_cpoles(hsrc, evt)
  global h1 h2
  set(h1.radio_add, 'Value', 1);
  set (h1.editor_list, "Value", 3);
endfunction

## Menu tab to add zeros
function call_add_zeros(hsrc, evt)
  global h1 h2
  set(h1.radio_add, 'Value', 1);
  set (h1.editor_list, "Value", 4);
endfunction

## Menu tab to add complex zeros
function call_add_czeros(hsrc, evt)
  global h1 h2
  set(h1.radio_add, 'Value', 1);
  set (h1.editor_list, "Value", 5);
endfunction


function call_save_controlller(hsrc, evt)
  global h1 h2
  C = h1.C;
  save controller.mat C;
endfunction

function call_menuedit(hsrc, evt)
  global h3
  
  set(3, 'Visible', 'on');

endfunction

function call_pendig(hsrc, evt)
  disp('Pending Function');
endfunction

## UI Elements 

## Push buttons
h1.btn_savecontroller = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Save Controller",
                                "callback", @update_plot,
                                "position", [0.5 0 0.2 0.06]);  
                                
## Labels
h1.lbl_diagrams = uicontrol ("style", "text",
                               "units", "normalized",
                               "string", "Diagrams:",
                               "horizontalalignment", "left",
                               "position", [0.05 0.35 0.35 0.08]);

h1.lbl_plant = uicontrol ("style", "text",
                               "units", "normalized",
                               "string", "Transfer function : ... wainting for input ...",
                               "horizontalalignment", "left",
                               "position", [0.05 0.1 0.35 0.06]); 
            
h1.rlocuseditor_label = uicontrol ("style", "text",
                                 "units", "normalized",
                                 "string", "Root Locus Editor",
                                 "horizontalalignment", "left",
                                 "position", [0.5 0.35 0.16 0.08]); 
                                 
h1.gain_label = uicontrol ("style", "text",
                                 "units", "normalized",
                                 "string", "Adjust Gain:",
                                 "horizontalalignment", "left",
                                 "position", [0.6 0.3 0.1 0.08]); 
                                 
## Radios        
h1.radio_bode = uicontrol ("style", "radiobutton",
                                    "units", "normalized",
                                    "string", "Bode",
                                    "callback", @update_plot,
                                    "value", 0,
                                    "position", [0.05 0.25 0.15 0.04]);
                                    
h1.radio_locus = uicontrol ("style", "radiobutton",
                                   "units", "normalized",
                                   "string", "Root Locus",
                                   "callback", @update_plot,
                                   "position", [0.05 0.31 0.15 0.04]);

h1.radio_nyquist = uicontrol ("style", "radiobutton",
                                    "units", "normalized",
                                    "string", "Nyquist",
                                    "callback", @update_plot,
                                    "value", 0,
                                   "position", [0.05 0.19 0.15 0.04]);
                            
h1.radio_dragging = uicontrol ("style", "radiobutton",
                                   "units", "normalized",
                                   "string", "Adjust",
                                   "callback", @update_plot,
                                 "position", [0.7 0.36 0.08 0.08]); 
                                   
h1.radio_add = uicontrol ("style", "radiobutton",
                                   "units", "normalized",
                                   "string", "Add",
                                   "callback", @update_plot,
                                 "position", [0.79 0.36 0.08 0.08]); 
                                 
h1.radio_delete = uicontrol ("style", "radiobutton",
                                   "units", "normalized",
                                   "string", "Delete",
                                   "callback", @update_plot,
                                 "position", [0.87 0.36 0.08 0.08]); 

## Editor List
h1.editor_list = uicontrol ("style", "listbox",
                                "units", "normalized",
                                "string", {"none",
                                           "'x' Real Pole",
                                           "'xx' Complex Pole",
                                           "'o' Real Zero",
                                           "'oo' Complex Zero",
                                           "Integrator",
                                           "Differentiator",
                                           "Lead", 
                                           "Lag", 
                                           "Notch"}, #"callback", @down_fig,
                                "position", [0.5 0.08 0.38 0.22]);

## Edit Box
h1.enter_plant = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "Enter with Plant",
                               "callback", @update_plot,
                               "position", [0.05 0.05 0.35 0.06]);   
                               
## Slider
h1.slider_gain = uicontrol ("style", "slider",
                                   "units", "normalized",
                                   "string", "Gain",
                                   "min", 0.01,
                                   "max", 100,
                                   "value", 1,
                                   "callback", @slider_adjustgain,
                                 "position", [0.7 0.32 0.25 0.04]); 

## Calbacks
set (fig2, "windowbuttondownfcn", @down_fig);
##set (fig2, "windowbuttonmotionfcn", @update_clgain)
set (fig2, "windowbuttonupfcn", @release_click)

set (fig1, "color", get(0, "defaultuicontrolbackgroundcolor"))
guidata (fig1, h1)
guidata (fig2, h2)
update_plot (true);

editcontroller

