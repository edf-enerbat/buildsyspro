﻿within BuildSysPro.Utilities.Data.Solids;
record DeepCarpet =  BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.067,
    rho=200,
    c=1200) "Deep carpet thickness=10 mm (source Ca-Sis)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction du rho (1500 > 200 kg/m3)</p>
</html>"));
