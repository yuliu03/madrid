<html>

<head>

<title> Upload a File </title>

</head>

<body bgcolor="#FFFFFF">

<form enctype="multipart/form-data" name="frmUploadFile" action="grabfile.php" method="post">

<a href="http://www.devarticles.com">

<img border="0" src="http://www.devarticles.com/dlogo.gif">

</a>

<table border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" width="100%">

<tr>

<td width="100%" bgcolor="#FF9900" height="22" colspan="2">

<p style="margin-left: 10"><b><font face="Verdana" size="2" color="#FFFFFF">

Upload a File</font></b></td>

</tr>

<tr>

<td width="100%" bgcolor="#FFE3BB" colspan="2">

<p style="margin-left: 10; margin-right: 10"><font face="Verdana" size="2">

<br>Please select a file from your local computer to upload to our web server 

for saving in our database. This file can be of any type you like. Once you 

have chosen a file, please click on the &quot;Upload this file&quot; button below.&nbsp;

&nbsp;<br>&nbsp;</font></td>

</tr>

<tr>

<td width="15%" bgcolor="#FFE3BB">

<p style="margin-left: 10"><font face="Verdana" size="2">

File Description:</font></td>

<td width="85%" bgcolor="#FFE3BB">

<input type="text" name="strDesc" size="20" maxlength="50"></td>

</tr>

<tr>

<td width="15%" bgcolor="#FFE3BB">

<p style="margin-left: 10"><font face="Verdana" size="2">File Location:</font></td>

<td width="85%" bgcolor="#FFE3BB">

<font face="Verdana" size="2">

<input type="file" name="fileUpload" size="20"></font></td>

</tr>

<tr>

<td width="33%" bgcolor="#FFE3BB">

<p style="margin-left: 10"><font face="Verdana" size="2">

<br>

<br>

&nbsp;</font></td>

<td width="67%" bgcolor="#FFE3BB">

<font face="Verdana" size="2">

<input type="submit" value="Upload this file" name="cmdSubmit"></font></td>

</tr>

</table>

</form>

</body>

</html>