within BuildSysPro.Building.Zones.HeatTransfer;
model SimplifiedZone2
  "One-zone simplified model with equivalent building envelope component (roof, wall, floor)"

// General properties
parameter Integer NbNiveaux "Number of floors, minimum = 1" annotation(Dialog(group="Global parameters"));
parameter Modelica.SIunits.Volume Vair=240 "Air volume" annotation(Dialog(group="Global parameters"));
parameter Modelica.SIunits.Area SH=100 "Living surface area" annotation(Dialog(group="Global parameters"));
    parameter Real renouv "Ventilation and/or infiltration flow [vol/h]" annotation(Dialog(group="Global parameters"));
  parameter Modelica.SIunits.ThermalConductance
    Psi_L "Thermal bridge coefficient" annotation(Dialog(group="Global parameters"));

// Glazing parameters
parameter Modelica.SIunits.Area SurfaceVitree "Total glazed surface"
                                 annotation(Dialog(group="Glazing"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer       U=1
    "Glazing deperditive coefficient" annotation(Dialog(group="Glazing"));

parameter Real Tr=0.7 "Transmittance"   annotation(Dialog(group="Glazing"));
parameter Real AbsVitrage=0.1 "Absorptance" annotation(Dialog(group="Glazing"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_Vitrage=16.7
    "Convective heat transfer coefficient on the outer face"                       annotation(Dialog(group="Glazing"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_Vitrage=9.1
    "Convective heat transfer coefficient on the inner face"                       annotation(Dialog(group="Glazing"));

// Walls parameters
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracParoiExt
    "External walls definition"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group="Walls"));
parameter Modelica.SIunits.Area SParoiExt
    "Deperditive surface area of vertical walls" annotation(Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_ParoiExt=25
    "Convective heat transfer coefficient on the outer face for the vertical walls"      annotation(Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_ParoiExt=7.7
    "Convective heat transfer coefficient on the inner face for the vertical walls"     annotation(Dialog(group="Walls"));

  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracPlancher
    "Floor definition"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_inf_Plancher=25
    "Convective heat transfer coefficient on the lower face for the floors"           annotation(Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_sup_Plancher=7.7
    "Convective heat transfer coefficient on the upper face for the floors"         annotation(Dialog(group="Walls"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracToiture
    "Roof definition"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group="Walls"));
    parameter Modelica.SIunits.Area SToiture
    "Deperditive surface area of the roofs"
                                         annotation(Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_Toiture=25
    "Convective heat transfer coefficient on the outer face for the roofs"          annotation(Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_Toiture=7.7
    "Convective heat transfer coefficient on the inner face for the roofs"              annotation(Dialog(group="Walls"));

parameter Real b=1 "Weighting coefficient for non-heated zones"
                                                 annotation(Dialog(group="Walls"));

parameter Real AbsParois=0.8 "Absorptance of outer walls SWR"
                                 annotation(Dialog(group="Walls"));
parameter Real epsParois=0.9 "Outer walls emissivity in LWR" annotation(Dialog(group="Walls"));

// Initialisation
parameter Modelica.SIunits.Temperature Tinit=293.15
    "Initialisation temperature"  annotation(Dialog(tab="Initialisation"));

// Internal parameters
protected
parameter Modelica.SIunits.CoefficientOfHeatTransfer       k=1/(1/U-1/hs_ext_Vitrage-1/hs_int_Vitrage)
    "Conductive heat transfer coefficient for the glazed surfaces";
parameter Modelica.SIunits.Length hTotal=Vair*(NbNiveaux/SH)
    "Total building height";
parameter Modelica.SIunits.Area Sdeper=4*hTotal*sqrt(SH/NbNiveaux)+2*Splancher
    "Total deperditive surface area";
parameter Modelica.SIunits.Area Swin=SurfaceVitree
    "Total deperditive surface area of glazed surface";
parameter Modelica.SIunits.Area Sop=Sdeper-Swin
    "Total deperditive surface area of opaque walls";
parameter Modelica.SIunits.Area Splancher=SH/NbNiveaux
    "Total deperditive surface area of the lowest floor";

// Internal components
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tinit) "Air node"
    annotation (Placement(transformation(extent={{50,4},{70,24}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall paroiExt(
    caracParoi(
      n=caracParoiExt.n,
      mat=caracParoiExt.mat,
      m=caracParoiExt.m,
      e=caracParoiExt.e),
    Tp=Tinit,
    RadExterne=true,
    GLOext=false,
    S=SParoiExt,
    AbsParoi=AbsParois,
    hs_ext=hs_ext_ParoiExt,
    hs_int=hs_int_ParoiExt) "External walls"
    annotation (Placement(transformation(extent={{-8,40},{12,60}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleGlazing vitrage(
    S=SurfaceVitree,
    k=k,
    Tr=Tr,
    Abs=AbsVitrage,
    hs_ext=hs_ext_Vitrage,
    hs_int=hs_int_Vitrage) "Glazing surface"
    annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall plancher(
    caracParoi(
      n=caracPlancher.n,
      m=caracPlancher.m,
      e=caracPlancher.e,
      mat=caracPlancher.mat,
      positionIsolant=caracPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher,
    hs_ext=hs_inf_Plancher,
    hs_int=hs_sup_Plancher,
    RadExterne=false,
    RadInterne=true,
    GLOext=false) "Lowest floor"
    annotation (Placement(transformation(extent={{-8,-92},{12,-72}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall toiture(
    Tp=Tinit,
    RadExterne=true,
    AbsParoi=AbsParois,
    caracParoi(
      n=caracToiture.n,
      mat=caracToiture.mat,
      m=caracToiture.m,
      e=caracToiture.e),
    GLOext=false,
    S=SToiture,
    hs_ext=hs_ext_Toiture,
    hs_int=hs_int_Toiture) "Roofs"
    annotation (Placement(transformation(extent={{-8,78},{12,98}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall plancherInt(
    caracParoi(
      n=caracPlancher.n,
      m=caracPlancher.m,
      e=caracPlancher.e,
      mat=caracPlancher.mat,
      positionIsolant=caracPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher*(NbNiveaux - 1),
    hs_ext=hs_inf_Plancher,
    hs_int=hs_sup_Plancher,
    RadInterne=true) if NbNiveaux > 1 "intermediate floors"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-70})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal ventilationSimple(Qv=
        renouv*Vair)
    annotation (Placement(transformation(extent={{-12,-116},{8,-96}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.ThermalBridge pontThermique(
    L=1, k=Psi_L*1)           annotation (
      Placement(transformation(extent={{-12,-138},
            {8,-118}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-22,8},{-18,12}}), iconTransformation(
          extent={{-192,4},{-172,24}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tint annotation (
      Placement(transformation(extent={{18,8},{22,12}}), iconTransformation(
          extent={{60,-76},{80,-56}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient coefficientBsol(b=b)
    annotation (Placement(transformation(extent={{-46,-94},{-26,-74}})));
  Modelica.Blocks.Math.Gain gainTransmisPlancher(k=1/NbNiveaux) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={28,-42})));
  Modelica.Blocks.Math.Gain gainTransmisPlancherIntermediaire(k=(NbNiveaux - 1)/
        NbNiveaux) if
               NbNiveaux>1 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={38,-60})));
// Public components
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tairext
    "Air temperature"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}}),
        iconTransformation(extent={{-100,-120},{-80,-100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tairint
    "Indoor air heat port"
    annotation (Placement(transformation(extent={{80,0},{100,20}}),
        iconTransformation(extent={{80,-60},{100,-40}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncVitrage
    "Irradiation for absorption on glazing surface" annotation (Placement(
        transformation(extent={{-120,-10},{-80,30}}), iconTransformation(extent=
           {{-100,10},{-80,30}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncParoi
    "Irradiation for absorption on external walls" annotation (Placement(
        transformation(extent={{-120,30},{-80,70}}), iconTransformation(extent={
            {-100,30},{-80,50}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput
    FluxIncTrVitrage
    "Transmitted irradiation through glazing (must take into account the influence of incidence)"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncToiture
    "Irradiation for absorption on external roofs" annotation (Placement(
        transformation(extent={{-120,70},{-80,110}}), iconTransformation(extent=
           {{-100,50},{-80,70}})));
BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a   Ts[2]
    "Surface temperature for LW radiation (roof and external walls)"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}}),
        iconTransformation(extent={{-100,80},{-80,100}})));

equation
// Air node and internal ports
  connect(noeudAir.port_a, Tairint) annotation (Line(
      points={{60,10},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tint) annotation (Line(
      points={{60,10},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tairext, Text) annotation (Line(
      points={{-90,-70},{-56,-70},{-56,10},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Boundary conditions
  connect(coefficientBsol.port_int, Tint) annotation (Line(
      points={{-45,-87},{-45,-91.5},{20,-91.5},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.port_ext, Text) annotation (Line(
      points={{-45,-81},{-45,-77.5},{-20,-77.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Floor connections
  connect(plancher.T_int, Tint)
                           annotation (Line(
      points={{11,-85},{11,-82.5},{20,-82.5},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.Tponder, plancher.T_ext) annotation (Line(
      points={{-31,-84.2},{-29.5,-84.2},{-29.5,-85},{-7,-85}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plancher.FluxAbsInt, gainTransmisPlancher.y) annotation (Line(
      points={{5,-77},{28,-77},{28,-48.6}},
      color={0,0,127},
      smooth=Smooth.None));

// Connexions de la toiture
  connect(Tairext, toiture.T_ext) annotation (Line(points={{-90,-70},{-56,-70},{
          -56,85},{-7,85}}, color={191,0,0}));
  connect(toiture.T_int, noeudAir.port_a) annotation (Line(points={{11,85},{20,85},{20,10},
          {60,10}},                         color={191,0,0}));
// Ventilation
  connect(ventilationSimple.port_b, Tint) annotation (Line(
      points={{7,-106},{20,-106},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ventilationSimple.port_a, Text) annotation (Line(
      points={{-11,-106},{-20,-106},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Glazing
  connect(vitrage.T_ext, Text)     annotation (Line(
      points={{-9,-35},{-9,-30.5},{-20,-30.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrage.T_int, Tint)     annotation (Line(
      points={{9,-35},{20,-35},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrage.CLOTr, gainTransmisPlancherIntermediaire.u) annotation (Line(
      points={{9,-27},{37.5,-27},{37.5,-52.8},{38,-52.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(gainTransmisPlancher.u, vitrage.CLOTr) annotation (Line(
      points={{28,-34.8},{28,-27},{9,-27}},
      color={255,170,85},
      smooth=Smooth.None));
// External walls
  connect(paroiExt.T_int, Tint)     annotation (Line(
      points={{11,47},{20,47},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiExt.T_ext, Text)     annotation (Line(
      points={{-7,47},{-20,47},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Intermediate floors
  connect(plancherInt.FluxAbsInt, gainTransmisPlancherIntermediaire.y)
    annotation (Line(
      points={{65,-75},{38,-75},{38,-66.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(plancherInt.T_ext, noeudAir.port_a) annotation (Line(
      points={{77,-67},{82,-67},{82,-14},{60,-14},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plancherInt.T_int, noeudAir.port_a) annotation (Line(
      points={{59,-67},{50,-67},{50,-14},{60,-14},{60,10}},
      color={255,0,0},
      smooth=Smooth.None));
      // Connexion for external LWR calculation
  connect(paroiExt.Ts_ext, Ts[1]) annotation (Line(points={{-1,47},
          {-0.5,47},{-0.5,105},{-90,105}},
                      color={191,0,0}));
  connect(Ts[2], toiture.Ts_ext)
    annotation (Line(points={{-90,115},{0,115},{0,85},{-1,85}}, color={191,0,0}));
    // Thermal bridge
  connect(pontThermique.T_int, Tint) annotation (
     Line(points={{7,-128},{20,-128},{20,10}},
        color={191,0,0}));
  connect(pontThermique.T_ext, Text) annotation (
     Line(points={{-11,-128},{-20,-128},{-20,10}},
        color={191,0,0}));
  connect(FluxIncToiture, toiture.FluxIncExt) annotation (Line(points={{-100,
          90},{-54,90},{-54,93},{-1,93}}, color={255,192,1}));
  connect(FluxIncParoi, paroiExt.FluxIncExt) annotation (Line(points={{-100,
          50},{-52,50},{-52,55},{-1,55}}, color={255,192,1}));
  connect(FluxIncVitrage, vitrage.FluxIncExt) annotation (Line(points={{-100,
          10},{-54,10},{-54,-27},{-3,-27}}, color={255,192,1}));
  connect(FluxIncTrVitrage, vitrage.FluxTr) annotation (Line(points={{-100,
          -30},{-3,-30}},          color={255,192,1}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -140},{100,120}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-140},{100,120}}), graphics={
        Polygon(
          points={{-100,80},{-60,40},{-60,-120},{-100,-78},{-100,80}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{-100,80},{38,80},{100,40},{-60,40},{-100,80}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,40},{100,40},{100,-120},{-60,-120},{-60,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Polygon(
          points={{-46,34},{-46,14},{-8,14},{-8,34},{-46,34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,0},{-46,-20},{-8,-20},{-8,0},{-46,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-40},{-48,-60},{-10,-60},{-10,-40},{-48,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-74},{-48,-94},{-10,-94},{-10,-74},{-48,-74}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,-74},{36,-94},{74,-94},{74,-74},{36,-74}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,-40},{36,-60},{74,-60},{74,-40},{36,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,0},{36,-20},{74,-20},{74,0},{36,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,34},{36,14},{74,14},{74,34},{36,34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,60},{-90,40},{-70,20},{-70,40},{-90,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,20},{-90,0},{-70,-20},{-70,0},{-90,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,-20},{-90,-40},{-70,-60},{-70,-40},{-90,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,-60},{-90,-80},{-70,-100},{-70,-80},{-90,-60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i><b>Linearised and time-invariant model of a single zone considering equivalent building components</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows the representation of Individual House / Collective Housing / Tertiary Building in single zone. The modelling is simplified to consider only an equivalent external wall and an equivalent glazing surface both being independant of the orientation.</p>
<p>The level of thermal losses represented by Ubat is a parameter of the model. This model leads to a linear time-invariant model that can be reduced.</p>
<p><b>Geometry</b></p>
<p>Model of a parallelepiped 0D-1D square section single-zone. The building height depends on the number of levels (<code>NbNiveau</code>), on total air volume (<code>Vair</code>) and on the living area (<code>SH</code>). Glazing are defined by a total surface.</p>
<p><b>Building typology</b></p>
<p>Constructive system (materials and layers thicknesses) are considered in detail through wall definition <code>caracParoiExt, caracPlancher</code>...</p>
<p>Inertia is adjustable by choosing the constructive mode.</p>
<p><b>Physics</b></p>
<p>The building envelope is decomposed into 3 equivalent models for external walls, roof and floor. The external wall  and roof models are subject to short-wave and long-wave radiations (SWR and LWR).</p>
<p>Long-wave radiations on the external walls and roof are outsourced and should be computed through the <code>Ts</code> connector.</p>
<p>The calculation of absorbed and transmitted irradiations is outsourced of this model and is performed by a <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.SolarBC\">SolarBC</a> model. This calculation is detailed and considers the influence of the walls and glazing orientation. Therefore the non-linear incidence of the angle of incidence for short-wave radiation, is outsourced. The transmitted irradiation through the glazing is absorbed on floor(s) surface.</p>
<p>The coefficient B defined a boundary condition in term of temperature on the  outer face of the lowest floor.

<p><u><b>Bibliography</b></u></p>
<p>Refer to <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall\">walls</a> and <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\">glazings</a> modelling assumptions.</p>
<p> Eui-Jong Kim, Gilles Plessis, Jean-Luc Hubert, Jean-Jacques Roux, 2014.<i>Urban energy simulation: Simplification and reduction of building envelope models</i>. Energy and Buildings 84 p193-202.
<p><u><b>Instructions for use</b></u></p>
<p>The irradiation connectors should be connected to a <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone\">FLUXzone</a> model. The outdoor temperature port must be connected to a weather data reader <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Meteofile\">Meteofile</a>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis, Hassan Bouia 07/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Gilles PLESSIS, Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gilles Plessis 07/2015 : Mod&egrave;le d&eacute;riv&eacute; de MonozoneSimplifie de BuildSysPro 2015.04 pour les besoin du projet ANR MERUBBI.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Ajout d&apos;un composant pour la toiture et pont thermique.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Les &eacute;changes GLO lin&eacute;aire sont supprim&eacute;s pour &ecirc;tre externalis&eacute; via le port Ts gr&acirc;ce &agrave; un calcul de facteur de forme.</span></p>
</html>"));
end SimplifiedZone2;
