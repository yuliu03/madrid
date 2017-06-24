var ASPx = {}, dx = {};
(function () {
ASPx.EmptyObject = { };
ASPx.FalseFunction = function() { return false; }
ASPx.SSLSecureBlankUrl = '/DXR.axd?r=1_0-Zneme';
ASPx.EmptyImageUrl = '/DXR.axd?r=1_35-Zneme';
ASPx.VersionInfo = 'Version=\'16.2.5.0\', File Version=\'16.2.5.0\', Date Modified=\'01/03/2017 21:26:04\'';
ASPx.InvalidDimension = -10000;
ASPx.InvalidPosition = -10000;
ASPx.AbsoluteLeftPosition = -10000;
ASPx.EmptyGuid = "00000000-0000-0000-0000-000000000000";
ASPx.CallbackSeparator = ":";
ASPx.ItemIndexSeparator = "i";
ASPx.CallbackResultPrefix = "/*DX*/";
ASPx.AccessibilityEmptyUrl = "javascript:;";
ASPx.AccessibilityPronounceTimeout = 500;
ASPx.PossibleNumberDecimalSeparators = [",", "."];
ASPx.CultureInfo = {
 twoDigitYearMax: 2029,
 ts: ":",
 ds: "/",
 am: "AM",
 pm: "PM",
 monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", ""],
 genMonthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", ""],
 abbrMonthNames: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""],
 abbrDayNames: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
 dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
 numDecimalPoint: ".",
 numPrec: 2,
 numGroupSeparator: ",", 
 numGroups: [ 3 ],
 numNegPattern: 1,
 numPosInf: "Infinity", 
 numNegInf: "-Infinity", 
 numNan: "NaN",
 currency: "$",
 currDecimalPoint: ".",
 currPrec: 2,
 currGroupSeparator: ",",
 currGroups: [ 3 ],
 currPosPattern: 0,
 currNegPattern: 0,
 percentPattern: 0,
 shortTime: "h:mm tt",
 longTime: "h:mm:ss tt",
 shortDate: "M/d/yyyy",
 longDate: "dddd, MMMM d, yyyy",
 monthDay: "MMMM d",
 yearMonth: "MMMM yyyy"
};
ASPx.CultureInfo.genMonthNames = ASPx.CultureInfo.monthNames;
ASPx.Position = {
 Left: "Left",
 Right: "Right",
 Top: "Top",
 Bottom: "Bottom"
};
var DateUtils = { };
DateUtils.GetInvariantDateString = function(date) {
 if(!date)
  return "01/01/0001";
 var day = date.getDate();
 var month = date.getMonth() + 1;
 var year = date.getFullYear();
 var result = "";
 if(month < 10)
  result += "0";
 result += month.toString() + "/";
 if(day < 10)
  result += "0";
 result += day.toString() + "/";
 if(year < 1000)
  result += "0";
 result += year.toString();
 return result;
}
DateUtils.GetInvariantDateTimeString = function(date) {
 var dateTimeString = DateUtils.GetInvariantDateString(date);
 var time = {
  h: date.getHours(),
  m: date.getMinutes(),
  s: date.getSeconds()
 };
 for(var key in time) {
  var str = time[key].toString();
  if(str.length < 2)
   str = "0" + str;
  time[key] = str;
 }
 dateTimeString += " " + time.h + ":" + time.m + ":" + time.s;
 var msec = date.getMilliseconds();
 if(msec > 0)
  dateTimeString += "." + ("000" + msec.toString()).substr(-3);
 return dateTimeString;
}
DateUtils.ExpandTwoDigitYear = function(value) {
 value += 1900;
 if(value + 99 < ASPx.CultureInfo.twoDigitYearMax)
  value += 100;
 return value;  
}
DateUtils.ToUtcTime = function(date) {
 var result = new Date();
 result.setTime(date.valueOf() + 60000 * date.getTimezoneOffset());
 return result;
}
DateUtils.ToLocalTime = function(date) {
 var result = new Date();
 result.setTime(date.valueOf() - 60000 * date.getTimezoneOffset());
 return result; 
}
DateUtils.AreDatesEqualExact = function(date1, date2) {
 if(date1 == null && date2 == null)
  return true;
 if(date1 == null || date2 == null)
  return false;
 return date1.getTime() == date2.getTime(); 
}
DateUtils.FixTimezoneGap = function(oldDate, newDate) {
 var diff = newDate.getHours() - oldDate.getHours();
 if(diff == 0)
  return;
 var sign = (diff == 1 || diff == -23) ? -1 : 1;
 var trial = new Date(newDate.getTime() + sign * 3600000);
 var isDateChangedAsExpected = newDate.getHours() - trial.getHours() === diff;
 if(isDateChangedAsExpected && (sign > 0 || trial.getDate() == newDate.getDate()))
  newDate.setTime(trial.getTime());
}
ASPx.DateUtils = DateUtils;
var Timer = { };
Timer.ClearTimer = function(timerID){
 if(timerID > -1)
  window.clearTimeout(timerID);
 return -1;
}
Timer.ClearInterval = function(timerID){
 if(timerID > -1)
  window.clearInterval(timerID);
 return -1;
}
var setControlBoundTimer = function(handler, control, setTimerFunction, clearTimerFunction, delay) {
 var timerId;
 var getTimerId = function() { return timerId };
 var boundHandler = function() {
  var controlExists = control && ASPx.GetControlCollection().Get(control.name) === control;
  if(controlExists)
   handler.aspxBind(control)();
  else
   clearTimerFunction(getTimerId());
 }
 timerId = setTimerFunction(boundHandler, delay);
 return timerId;
}
Timer.SetControlBoundTimeout = function(handler, control, delay) {
 return setControlBoundTimer(handler, control, window.setTimeout, Timer.ClearTimer, delay);
}
Timer.SetControlBoundInterval = function(handler, control, delay) {
 return setControlBoundTimer(handler, control, window.setInterval, Timer.ClearInterval, delay);
}
Timer.Throttle = function(func, delay) {
 var isThrottled = false,
   savedArgs,
   savedThis = this;
 function wrapper() {
  if(isThrottled) {
   savedArgs = arguments;
   savedThis = this;
   return;
  }
  func.apply(this, arguments);
  isThrottled = true;
  setTimeout(function() {
   isThrottled = false;
   if(savedArgs) {
    wrapper.apply(savedThis, savedArgs);
    savedArgs = null;
   }
  }, delay);
 }
 wrapper.cancel = function() {
  clearTimeout(delay);
  delay = savedArgs = savedThis = null;
 };
 return wrapper;
}
ASPx.Timer = Timer;
var Browser = { };
Browser.UserAgent = navigator.userAgent.toLowerCase();
Browser.Mozilla = false;
Browser.IE = false;
Browser.Firefox = false;
Browser.Netscape = false;
Browser.Safari = false;
Browser.Chrome = false;
Browser.Opera = false;
Browser.Edge = false;
Browser.Version = undefined; 
Browser.MajorVersion = undefined; 
Browser.WindowsPlatform = false;
Browser.MacOSPlatform = false;
Browser.MacOSMobilePlatform = false;
Browser.AndroidMobilePlatform = false;
Browser.PlaformMajorVersion = false;
Browser.WindowsPhonePlatform = false;
Browser.AndroidDefaultBrowser = false;
Browser.AndroidChromeBrowser = false;
Browser.SamsungAndroidDevice = false;
Browser.WebKitTouchUI = false;
Browser.MSTouchUI = false;
Browser.TouchUI = false;
Browser.WebKitFamily = false; 
Browser.NetscapeFamily = false; 
Browser.HardwareAcceleration = false;
Browser.VirtualKeyboardSupported = false;
Browser.Info = "";
function indentPlatformMajorVersion(userAgent) {
 var regex = /(?:(?:windows nt|macintosh|mac os|cpu os|cpu iphone os|android|windows phone|linux) )(\d+)(?:[-0-9_.])*/;
 var matches = regex.exec(userAgent);
 if(matches)
  Browser.PlaformMajorVersion = matches[1];
}
function getIECompatibleVersionString() {
 if(document.compatible) {
  for(var i = 0; i < document.compatible.length; i++)
   if(document.compatible[i].userAgent === "IE" && document.compatible[i].version)
    return document.compatible[i].version.toLowerCase();
 }
 return "";
}
Browser.IdentUserAgent = function(userAgent, ignoreDocumentMode) {
 var browserTypesOrderedList = [ "Mozilla", "IE", "Firefox", "Netscape", "Safari", "Chrome", "Opera", "Opera10", "Edge" ];
 var defaultBrowserType = "IE";
 var defaultPlatform = "Win";
 var defaultVersions = { Safari: 2, Chrome: 0.1, Mozilla: 1.9, Netscape: 8, Firefox: 2, Opera: 9, IE: 6, Edge: 12 };
 if(!userAgent || userAgent.length == 0) {
  fillUserAgentInfo(browserTypesOrderedList, defaultBrowserType, defaultVersions[defaultBrowserType], defaultPlatform);
  return;
 }
 userAgent = userAgent.toLowerCase();
 indentPlatformMajorVersion(userAgent);
 try {
  var platformIdentStrings = {
   "Windows": "Win",
   "Macintosh": "Mac",
   "Mac OS": "Mac",
   "Mac_PowerPC": "Mac",
   "cpu os": "MacMobile",
   "cpu iphone os": "MacMobile",
   "Android": "Android",
   "!Windows Phone": "WinPhone",
   "!WPDesktop": "WinPhone",
   "!ZuneWP": "WinPhone"
  };
  var optSlashOrSpace = "(?:/|\\s*)?";
  var version = "(\\d+)(?:\\.((?:\\d+?[1-9])|\\d)0*?)?";
  var optVersion = "(?:" + version + ")?";
  var patterns = {
   Safari: "applewebkit(?:.*?(?:version/" + version + "[\\.\\w\\d]*?(?:\\s+mobile\/\\S*)?\\s+safari))?",
   Chrome: "(?:chrome|crios)(?!frame)" + optSlashOrSpace + optVersion,
   Mozilla: "mozilla(?:.*rv:" + optVersion + ".*Gecko)?",
   Netscape: "(?:netscape|navigator)\\d*/?\\s*" + optVersion,
   Firefox: "firefox" + optSlashOrSpace + optVersion,
   Opera: "(?:opera|opr)" + optSlashOrSpace + optVersion,
   Opera10: "opera.*\\s*version" + optSlashOrSpace + optVersion,
   IE: "msie\\s*" + optVersion,
   Edge: "edge" + optSlashOrSpace + optVersion
  };
  var browserType;
  var version = -1;
  for(var i = 0; i < browserTypesOrderedList.length; i++) {
   var browserTypeCandidate = browserTypesOrderedList[i];
   var regExp = new RegExp(patterns[browserTypeCandidate], "i");
   if(regExp.compile)
    regExp.compile(patterns[browserTypeCandidate], "i");
   var matches = regExp.exec(userAgent);
   if(matches && matches.index >= 0) {
    if(browserType == "IE" && version >= 11 && browserTypeCandidate == "Safari") 
     continue;
    browserType = browserTypeCandidate;
    if(browserType == "Opera10")
     browserType = "Opera";
    var tridentPattern = "trident" + optSlashOrSpace + optVersion;
    version = Browser.GetBrowserVersion(userAgent, matches, tridentPattern, getIECompatibleVersionString());
    if(browserType == "Mozilla" && version >= 11)
     browserType = "IE";
   }
  }
  if(!browserType)
   browserType = defaultBrowserType;
  var browserVersionDetected = version != -1;
  if(!browserVersionDetected)
   version = defaultVersions[browserType];
  var platform;
  var minOccurenceIndex = Number.MAX_VALUE;
  for(var identStr in platformIdentStrings) {
   if(!platformIdentStrings.hasOwnProperty(identStr)) continue;
   var importantIdent = identStr.substr(0,1) == "!";
   var occurenceIndex = userAgent.indexOf((importantIdent ? identStr.substr(1) : identStr).toLowerCase());
   if(occurenceIndex >= 0 && (occurenceIndex < minOccurenceIndex || importantIdent)) {
    minOccurenceIndex = importantIdent ? 0 : occurenceIndex;
    platform = platformIdentStrings[identStr];
   }
  }
  var samsungPattern = "SM-[A-Z]";
  var matches = userAgent.toUpperCase().match(samsungPattern);
  var isSamsungAndroidDevice = matches && matches.length > 0;
  if(platform == "WinPhone" && version < 9)
   version = Math.floor(getVersionFromTrident(userAgent, "trident" + optSlashOrSpace + optVersion));
  if(!ignoreDocumentMode && browserType == "IE" && version > 7 && document.documentMode < version)
   version = document.documentMode;
  if(platform == "WinPhone")
   version = Math.max(9, version);
  if(!platform)
   platform = defaultPlatform;
  if(platform == platformIdentStrings["cpu os"] && !browserVersionDetected) 
   version = 4;
  fillUserAgentInfo(browserTypesOrderedList, browserType, version, platform, isSamsungAndroidDevice);
 } catch(e) {
  fillUserAgentInfo(browserTypesOrderedList, defaultBrowserType, defaultVersions[defaultBrowserType], defaultPlatform);
 }
}
function getVersionFromMatches(matches) {
 var result = -1;
 var versionStr = "";
 if(matches[1]) {
  versionStr += matches[1];
  if(matches[2])
   versionStr += "." + matches[2];
 }
 if(versionStr != "") {
  result = parseFloat(versionStr);
  if(result == NaN)
   result = -1;
 }
 return result;
}
function getVersionFromTrident(userAgent, tridentPattern) {
 var tridentDiffFromVersion = 4;
 var matches = new RegExp(tridentPattern, "i").exec(userAgent);
 return getVersionFromMatches(matches) + tridentDiffFromVersion;
}
Browser.GetBrowserVersion = function(userAgent, matches, tridentPattern, ieCompatibleVersionString) {
 var version = getVersionFromMatches(matches);
 if(ieCompatibleVersionString) {
  var versionFromTrident = getVersionFromTrident(userAgent, tridentPattern);
  if(ieCompatibleVersionString === "edge" || parseInt(ieCompatibleVersionString) === versionFromTrident)
   return versionFromTrident;
 }
 return version;
}
function fillUserAgentInfo(browserTypesOrderedList, browserType, version, platform, isSamsungAndroidDevice) {
 for(var i = 0; i < browserTypesOrderedList.length; i++) {
  var type = browserTypesOrderedList[i];
  Browser[type] = type == browserType;
 }
 Browser.Version = Math.floor(10.0 * version) / 10.0;
 Browser.MajorVersion = Math.floor(Browser.Version);
 Browser.WindowsPlatform = platform == "Win" || platform == "WinPhone";
 Browser.MacOSPlatform = platform == "Mac";
 Browser.MacOSMobilePlatform = platform == "MacMobile";
 Browser.AndroidMobilePlatform = platform == "Android";
 Browser.WindowsPhonePlatform = platform == "WinPhone";
 Browser.WebKitFamily = Browser.Safari || Browser.Chrome || Browser.Opera && Browser.MajorVersion >= 15;
 Browser.NetscapeFamily = Browser.Netscape || Browser.Mozilla || Browser.Firefox;
 Browser.HardwareAcceleration = (Browser.IE && Browser.MajorVersion >= 9) || (Browser.Firefox && Browser.MajorVersion >= 4) || 
  (Browser.AndroidMobilePlatform && Browser.Chrome) || (Browser.Chrome && Browser.MajorVersion >= 37) || 
  (Browser.Safari && !Browser.WindowsPlatform) || Browser.Edge;
 Browser.WebKitTouchUI = Browser.MacOSMobilePlatform || Browser.AndroidMobilePlatform;
 var isIETouchUI = Browser.IE && Browser.MajorVersion > 9 && Browser.WindowsPlatform && Browser.UserAgent.toLowerCase().indexOf("touch") >= 0;
 Browser.MSTouchUI = isIETouchUI || (Browser.Edge && !!window.navigator.maxTouchPoints);
 Browser.TouchUI = Browser.WebKitTouchUI || Browser.MSTouchUI;
 Browser.MobileUI = Browser.WebKitTouchUI || Browser.WindowsPhonePlatform;
 Browser.AndroidDefaultBrowser = Browser.AndroidMobilePlatform && !Browser.Chrome;
 Browser.AndroidChromeBrowser = Browser.AndroidMobilePlatform && Browser.Chrome;
 if(isSamsungAndroidDevice)
  Browser.SamsungAndroidDevice = isSamsungAndroidDevice;
 if(Browser.MSTouchUI) {
  var isARMArchitecture = Browser.UserAgent.toLowerCase().indexOf("arm;") > -1;    
  Browser.VirtualKeyboardSupported = isARMArchitecture || Browser.WindowsPhonePlatform;   
 } else {
  Browser.VirtualKeyboardSupported = Browser.WebKitTouchUI;
 }
 fillDocumentElementBrowserTypeClassNames(browserTypesOrderedList);
}
function fillDocumentElementBrowserTypeClassNames(browserTypesOrderedList) {
 var documentElementClassName = "";
 var browserTypeslist = browserTypesOrderedList.concat(["WindowsPlatform", "MacOSPlatform", "MacOSMobilePlatform", "AndroidMobilePlatform",
   "WindowsPhonePlatform", "WebKitFamily", "WebKitTouchUI", "MSTouchUI", "TouchUI", "AndroidDefaultBrowser"]);
 for(var i = 0; i < browserTypeslist.length; i++) {
  var type = browserTypeslist[i];
  if(Browser[type])
   documentElementClassName += "dx" + type + " ";
 }
 documentElementClassName += "dxBrowserVersion-" + Browser.MajorVersion
 if(document && document.documentElement) {
  if(document.documentElement.className != "")
   documentElementClassName = " " + documentElementClassName;
  document.documentElement.className += documentElementClassName;
  Browser.Info = documentElementClassName;
 }
}
Browser.IdentUserAgent(Browser.UserAgent);
ASPx.Browser = Browser;
ASPx.BlankUrl = Browser.IE ? ASPx.SSLSecureBlankUrl : (Browser.Opera ? "about:blank" : "");
var Data = { };
Data.ArrayInsert = function(array, element, position){
 if(0 <= position && position < array.length){
  for(var i = array.length; i > position; i --)
   array[i] = array[i - 1];
  array[position] = element;
 }
 else
  array.push(element);
}
Data.ArrayRemove = function(array, element){
 var index = Data.ArrayIndexOf(array, element);
 if(index > -1) Data.ArrayRemoveAt(array, index);
}
Data.ArrayRemoveAt = function(array, index){
 if(index >= 0  && index < array.length){
  for(var i = index; i < array.length - 1; i++)
   array[i] = array[i + 1];
  array.pop();
 }
}
Data.ArrayClear = function(array){
 while(array.length > 0)
  array.pop();
}
Data.ArrayIndexOf = function(array, element, comparer) {
 if(!comparer) {
  for(var i = 0; i < array.length; i++) {
   if(array[i] == element)
    return i;
  }
 } else {
  for(var i = 0; i < array.length; i++) {
   if(comparer(array[i], element))
    return i;
  }
 }
 return -1;
}
Data.ArrayContains = function(array, element) { 
 return Data.ArrayIndexOf(array, element) >= 0;
}
Data.ArrayEqual = function(array1, array2) {
 var count1 = array1.length;
 var count2 = array2.length;
 if(count1 != count2)
  return false;
 for(var i = 0; i < count1; i++)
  if(array1[i] != array2[i])
   return false;
 return true;
}
Data.ArraySame = function(array1, array2) {
 if(array1.length !== array2.length)
  return false;
 return array1.every(function(elem) { return Data.ArrayContains(array2, elem) });
}
Data.ArrayGetIntegerEdgeValues = function(array) {
 var arrayToSort = Data.CollectionToArray(array);
 Data.ArrayIntegerAscendingSort(arrayToSort);
 return {
  start: arrayToSort[0],
  end: arrayToSort[arrayToSort.length - 1]
 }
}
Data.ArrayIntegerAscendingSort = function(array){
 Data.ArrayIntegerSort(array);
}
Data.ArrayIntegerSort = function(array, desc) {
 array.sort(function(i1, i2) {
  var res = 0;
  if(i1 > i2)
   res = 1;
  else if(i1 < i2)
   res = -1;
  if(desc)
   res *= -1;
  return res;
 });
},
Data.CollectionsUnionToArray = function(firstCollection, secondCollection) {
 var result = [];
 var firstCollectionLength = firstCollection.length;
 var secondCollectionLength = secondCollection.length;
 for(var i = 0; i <  firstCollectionLength + secondCollectionLength; i++) {
  if(i < firstCollectionLength) 
   result.push(firstCollection[i]);
  else 
   result.push(secondCollection[i - firstCollectionLength]);
 }  
 return result;
}
Data.CollectionToArray = function(collection) {
 var array = [];
 for(var i = 0; i < collection.length; i++)
  array.push(collection[i]);
 return array;
}
Data.CreateHashTableFromArray = function(array) {
 var hash = [];
 for(var i = 0; i < array.length; i++)
  hash[array[i]] = 1;
 return hash;
}
Data.CreateIndexHashTableFromArray = function(array) {
 var hash = [];
 for(var i = 0; i < array.length; i++)
  hash[array[i]] = i;
 return hash;
}
Data.ArrayToHash = function(array, getKeyFunc, getValueFunc) {
 if(!(array instanceof Array)) 
  return { };
 return array.reduce(function(map, element, index) { 
  var key = getKeyFunc(element, index);
  var value = getValueFunc(element, index);
  map[key] = value;
  return map; 
 }, { });
}
var defaultBinarySearchComparer = function(array, index, value) {
 var arrayElement = array[index];
 if(arrayElement == value)
  return 0;
 else
  return arrayElement < value ? -1 : 1;
};
Data.NearestLeftBinarySearchComparer = function(array, index, value) { 
 var arrayElement = array[index];
 var leftPoint = arrayElement < value;
 var lastLeftPoint = leftPoint && index == array.length - 1;
 var nearestLeftPoint = lastLeftPoint || (leftPoint && array[index + 1] >= value)
 if(nearestLeftPoint)
  return 0;
 else
  return arrayElement < value ? -1 : 1;
};
Data.ArrayBinarySearch = function(array, value, binarySearchComparer, startIndex, length) {
 if(!binarySearchComparer)
  binarySearchComparer = defaultBinarySearchComparer;
 if(!ASPx.IsExists(startIndex))
  startIndex = 0;
 if(!ASPx.IsExists(length))
  length = array.length - startIndex;  
 var endIndex = (startIndex + length) - 1;
 while(startIndex <= endIndex) {
  var middle =  (startIndex + ((endIndex - startIndex) >> 1));
  var compareResult = binarySearchComparer(array, middle, value);
  if(compareResult == 0)
   return middle;
  if(compareResult < 0)
   startIndex = middle + 1;
  else
   endIndex = middle - 1;
 }
 return -(startIndex + 1);
},
Data.ArrayFlatten = function(arrayOfArrays) {
 return [].concat.apply([], arrayOfArrays);
},
Data.GetDistinctArray = function(array) {
 var resultArray = [];
 for(var i = 0; i < array.length; i++) {
  var currentEntry = array[i];
  if(Data.ArrayIndexOf(resultArray, currentEntry) == -1) {
     resultArray.push(currentEntry);
  }
 }
 return resultArray;
}
Data.ForEach = function(arr, callback) {
 if(Array.prototype.forEach) {
  Array.prototype.forEach.call(arr, callback);
 } else {
  for(var i = 0, len = arr.length; i < len; i++) {
   callback(arr[i], i, arr);
  }
 }
},
Data.MergeHashTables = function(target, object) {
 if(!object || typeof (object) == "string")
  return target;
 if(!target)
  target = {};
 for(var key in object)
  if(key && !(key in target))
   target[key] = object[key];
 return target;
}
Data.Range = function(count, start) {
 count = parseInt(count) || 0;
 start = parseInt(start) || 0;
 if(count < 0) count = 0;
 if(start < 0) start = 0;
 return Array.apply(null, Array(count)).map(function(val, i) { return start + i; });
}
ASPx.Data = Data;
var Cookie = { };
Cookie.DelCookie = function(name){
 setCookieInternal(name, "", new Date(1970, 1, 1));
}
Cookie.GetCookie = function(name) {
 name = escape(name);
 var cookies = document.cookie.split(';');
 for(var i = 0; i < cookies.length; i++) {
  var cookie = Str.Trim(cookies[i]);
  if(cookie.indexOf(name + "=") == 0)
   return unescape(cookie.substring(name.length + 1, cookie.length));
  else if(cookie.indexOf(name + ";") == 0 || cookie === name)
   return "";
 }
 return null;
}
Cookie.SetCookie = function(name, value, expirationDate){
 if(!ASPx.IsExists(value)) {
  Cookie.DelCookie(name);
  return;
 }
 if(!ASPx.Ident.IsDate(expirationDate)) {
  expirationDate = new Date();
  expirationDate.setFullYear(expirationDate.getFullYear() + 1);
 }
 setCookieInternal(name, value, expirationDate);
}
function setCookieInternal(name, value, date){
 document.cookie = escape(name) + "=" + escape(value.toString()) + "; expires=" + date.toGMTString() + "; path=/";
}
ASPx.Cookie = Cookie;
ASPx.ImageUtils = {
 GetImageSrc: function (image){
  return image.src;
 },
 SetImageSrc: function(image, src){
  image.src = src;
 },
 SetSize: function(image, width, height){
  image.style.width = width + "px";
  image.style.height = height + "px";
 },
 GetSize: function(image, isWidth){
  return (isWidth ? image.offsetWidth : image.offsetHeight);
 }
};
var Str = { };
Str.ApplyReplacement = function(text, replecementTable) {
 if(typeof(text) != "string")
  text = text.toString();
 for(var i = 0; i < replecementTable.length; i++) {
  var replacement = replecementTable[i];
  text = text.replace(replacement[0], replacement[1]);
 }
 return text;
}
Str.CompleteReplace = function(text, regexp, newSubStr) {
 if(typeof(text) != "string")
  text = text.toString();
 var textPrev;
 do {
  textPrev = text;
  text = text.replace(regexp, newSubStr);
 } while(text != textPrev);
 return text;
}
Str.EncodeHtml = function(html) {
 return Str.ApplyReplacement(html, [
  [ /&amp;/g,  '&ampx;'  ], [ /&/g, '&amp;'  ],
  [ /&quot;/g, '&quotx;' ], [ /"/g, '&quot;' ],
  [ /&lt;/g,   '&ltx;'   ], [ /</g, '&lt;'   ],
  [ /&gt;/g,   '&gtx;'   ], [ />/g, '&gt;'   ]
 ]);
}
Str.DecodeHtml = function(html) {
 return Str.ApplyReplacement(html, [
  [ /&gt;/g,   '>' ], [ /&gtx;/g,  '&gt;'   ],
  [ /&lt;/g,   '<' ], [ /&ltx;/g,  '&lt;'   ],
  [ /&quot;/g, '"' ], [ /&quotx;/g,'&quot;' ],
  [ /&amp;/g,  '&' ], [ /&ampx;/g, '&amp;'  ]
 ]);
}
Str.TrimStart = function(str) { 
 return trimInternal(str, true);
}
Str.TrimEnd = function(str) { 
 return trimInternal(str, false, true);
}
Str.Trim = function(str) { 
 return trimInternal(str, true, true); 
}
var whiteSpaces = { 
 0x0009: 1, 0x000a: 1, 0x000b: 1, 0x000c: 1, 0x000d: 1, 0x0020: 1, 0x0085: 1, 
 0x00a0: 1, 0x1680: 1, 0x180e: 1, 0x2000: 1, 0x2001: 1, 0x2002: 1, 0x2003: 1, 
 0x2004: 1, 0x2005: 1, 0x2006: 1, 0x2007: 1, 0x2008: 1, 0x2009: 1, 0x200a: 1, 
 0x200b: 1, 0x2028: 1, 0x2029: 1, 0x202f: 1, 0x205f: 1, 0x3000: 1
};
var caretWidth = 1;
function trimInternal(source, trimStart, trimEnd) {
 var len = source.length;
 if(!len)
  return source;
 if(len < 0xBABA1) { 
  var result = source;
  if(trimStart) {
   result = result.replace(/^\s+/, "");
  }
  if(trimEnd) {
   result = result.replace(/\s+$/, "");
  }
  return result;  
 } else {
  var start = 0;
  if(trimEnd) {   
   while(len > 0 && whiteSpaces[source.charCodeAt(len - 1)]) {
    len--;
   }
  }
  if(trimStart && len > 0) {
   while(start < len && whiteSpaces[source.charCodeAt(start)]) { 
    start++; 
   }   
  }
  return source.substring(start, len);
 }
}
Str.Insert = function(str, subStr, index) { 
 var leftText = str.slice(0, index);
 var rightText = str.slice(index);
 return leftText + subStr + rightText;
}
Str.InsertEx = function(str, subStr, startIndex, endIndex) { 
 var leftText = str.slice(0, startIndex);
 var rightText = str.slice(endIndex);
 return leftText + subStr + rightText;
}
var greekSLFSigmaChar = String.fromCharCode(962);
var greekSLSigmaChar = String.fromCharCode(963);
Str.PrepareStringForFilter = function(s){
 s = s.toLowerCase();
 if(ASPx.Browser.WebKitFamily) {
  return s.replace(new RegExp(greekSLFSigmaChar, "g"), greekSLSigmaChar);
 }
 return s;
}
Str.GetCoincideCharCount = function(text, filter, textMatchingDelegate) {
 var coincideText = ASPx.Str.PrepareStringForFilter(filter);
 var originText = ASPx.Str.PrepareStringForFilter(text);
 while(coincideText != "" && !textMatchingDelegate(originText, coincideText)) {
  coincideText = coincideText.slice(0, -1);
 }
 return coincideText.length;
}
ASPx.Str = Str;
var Xml = { };
Xml.Parse = function(xmlStr) {
 if(window.DOMParser) {
  var parser = new DOMParser();
  return parser.parseFromString(xmlStr, "text/xml");
 }
 else if(window.ActiveXObject) {
  var xmlDoc = new window.ActiveXObject("Microsoft.XMLDOM");
  if(xmlDoc) {
   xmlDoc.async = false;
   xmlDoc.loadXML(xmlStr);
   return xmlDoc;
  }
 }
 return null;
}
ASPx.Xml = Xml;
ASPx.Key = {
 F1     : 112,
 F2     : 113,
 F3     : 114,
 F4     : 115,
 F5     : 116,
 F6     : 117,
 F7     : 118,
 F8     : 119,
 F9     : 120,
 F10    : 121,
 F11    : 122,
 F12    : 123,
 Ctrl   : 17,
 Shift  : 16,
 Alt    : 18,
 Enter  : 13,
 Home   : 36,
 End    : 35,
 Left   : 37,
 Right  : 39,
 Up     : 38,
 Down   : 40,
 PageUp    : 33,
 PageDown  : 34,
 Esc    : 27,
 Space  : 32,
 Tab    : 9,
 Backspace : 8,
 Delete    : 46,
 Insert    : 45,
 ContextMenu  : 93,
 Windows   : 91,
 Decimal   : 110
};
ASPx.KeyCode = {
 Backspace : 8,
 Tab    : 9,
 Enter  : 13,
 Pause  : 19,
 CapsLock  : 20,
 Esc    : 27,
 Space  : 32,
 PageUp    : 33,
 PageDown  : 34,
 End    : 35,
 Home   : 36,
 Left   : 37,
 Up     : 38,
 Right  : 39,
 Down   : 40,
 Insert    : 45,
 Delete    : 46,
 Key_0  : 48,
 Key_1  : 49,
 Key_2  : 50,
 Key_3  : 51,
 Key_4  : 52,
 Key_5  : 53,
 Key_6  : 54,
 Key_7  : 55,
 Key_8  : 56,
 Key_9  : 57,
 Key_a  : 65,
 Key_b  : 66,
 Key_c  : 67,
 Key_d  : 68,
 Key_e  : 69,
 Key_f  : 70,
 Key_g  : 71,
 Key_h  : 72,
 Key_i  : 73,
 Key_j  : 74,
 Key_k  : 75,
 Key_l  : 76,
 Key_m  : 77,
 Key_n  : 78,
 Key_o  : 79,
 Key_p  : 80,
 Key_q  : 81,
 Key_r  : 82,
 Key_s  : 83,
 Key_t  : 84,
 Key_u  : 85,
 Key_v  : 86,
 Key_w  : 87,
 Key_x  : 88,
 Key_y  : 89,
 Key_z  : 90,
 Windows   : 91,
 ContextMenu  : 93,
 Numpad_0  : 96,
 Numpad_1  : 97,
 Numpad_2  : 98,
 Numpad_3  : 99,
 Numpad_4  : 100,
 Numpad_5  : 101,
 Numpad_6  : 102,
 Numpad_7  : 103,
 Numpad_8  : 104,
 Numpad_9  : 105,
 Multiply  : 106,
 Add    : 107,
 Subtract  : 109,
 Decimal   : 110,
 Divide    : 111,
 F1     : 112,
 F2     : 113,
 F3     : 114,
 F4     : 115,
 F5     : 116,
 F6     : 117,
 F7     : 118,
 F8     : 119,
 F9     : 120,
 F10    : 121,
 F11    : 122,
 F12    : 123,
 NumLock   : 144,
 ScrollLock   : 145,
 Semicolon : 186,
 Equals    : 187,
 Comma  : 188,
 Dash   : 189,
 Period    : 190,
 ForwardSlash : 191,
 GraveAccent  : 192,
 OpenBracket  : 219,
 BackSlash : 220,
 CloseBracket : 221,
 SingleQuote  : 222
};
ASPx.ScrollBarMode = { Hidden: 0, Visible: 1, Auto: 2 };
ASPx.ColumnResizeMode = { None: 0, Control: 1, NextColumn: 2 };
var Selection = { };
Selection.Set = function(input, startPos, endPos, scrollToSelection) {
 if(!ASPx.IsExistsElement(input))
  return;
 if(Browser.VirtualKeyboardSupported && (ASPx.GetActiveElement() !== input || ASPx.VirtualKeyboardUI.getInputNativeFocusLocked()))
  return;
 var textLen = input.value.length;
 startPos = ASPx.GetDefinedValue(startPos, 0);
 endPos = ASPx.GetDefinedValue(endPos, textLen);
 if(startPos < 0)
  startPos = 0;
 if(endPos < 0 || endPos > textLen)
  endPos = textLen;
 if(startPos > endPos)
  startPos = endPos;
 var makeReadOnly = false;
 if(Browser.WebKitFamily && input.readOnly) {
  input.readOnly = false;
  makeReadOnly = true;
 }
 try {
  if(Browser.Firefox && Browser.Version >= 8) 
   input.setSelectionRange(startPos, endPos, "backward");
  else if(Browser.IE && input.createTextRange) {
   var range = input.createTextRange();
   range.collapse(true);
   range.moveStart("character", startPos);
   range.moveEnd("character", endPos - startPos);
   range.select();
  } else {
   forceScrollToSelectionRange(input, startPos, endPos);
   input.setSelectionRange(startPos, endPos);
  }
  if(Browser.Opera || Browser.Firefox || Browser.Chrome) 
   input.focus();
 } catch(e) { 
 }
 if(scrollToSelection && input.tagName == 'TEXTAREA') {
  var scrollHeight = input.scrollHeight;
  var approxCaretPos = startPos;
  var scrollTop = Math.max(Math.round(approxCaretPos * scrollHeight / textLen  - input.clientHeight / 2), 0);
  input.scrollTop = scrollTop;
 }
 if(makeReadOnly)
  input.readOnly = true;
}
var getTextWidthBeforePos = function(input, pos) {
 return ASPx.GetSizeOfText(input.value.toString().substr(0, pos), ASPx.GetCurrentStyle(input)).width;
}
var forceScrollToSelectionRange = function(input, startPos, endPos) {
 var widthBeforeStartPos = getTextWidthBeforePos(input, startPos) - caretWidth;
 var widthBeforeEndPos = getTextWidthBeforePos(input, endPos) + caretWidth;
 var inputRawWidth = input.offsetWidth - ASPx.GetLeftRightBordersAndPaddingsSummaryValue(input);
 if(input.scrollLeft < widthBeforeEndPos - inputRawWidth)
  input.scrollLeft = widthBeforeEndPos - inputRawWidth;
 else if(input.scrollLeft > widthBeforeStartPos)
  input.scrollLeft = widthBeforeStartPos;
}
Selection.GetInfo = function(input) {
 var start, end;
 if(Browser.IE && Browser.Version < 9) {
  var range = document.selection.createRange();
  var rangeCopy = range.duplicate();
  range.move('character', -input.value.length);
  range.setEndPoint('EndToStart', rangeCopy);
  start = range.text.length;
  end = start + rangeCopy.text.length;
 } else {
  try {
   start = input.selectionStart;
   end = input.selectionEnd;
  } catch (e) {
  }
 }
 return { startPos: start, endPos: end };
}
Selection.GetExtInfo = function(input) {
 var start = 0, end = 0, textLen = 0;
 if(Browser.IE && Browser.Version < 9) {
  var normalizedValue;
  var range, textInputRange, textInputEndRange;
  range = document.selection.createRange();
  if(range && range.parentElement() == input) {
   textLen = input.value.length;
   normalizedValue = input.value.replace(/\r\n/g, "\n");
   textInputRange = input.createTextRange();
   textInputRange.moveToBookmark(range.getBookmark());
   textInputEndRange = input.createTextRange();
   textInputEndRange.collapse(false);
   if(textInputRange.compareEndPoints("StartToEnd", textInputEndRange) > -1) {
    start = textLen;
    end = textLen;
   } else {
    start = normalizedValue.slice(0, start).split("\n").length - textInputRange.moveStart("character", -textLen) -1;
    if(textInputRange.compareEndPoints("EndToEnd", textInputEndRange) > -1)
     end = textLen;
    else
     end = normalizedValue.slice(0, end).split("\n").length - textInputRange.moveEnd("character", -textLen) - 1;    
   }
  }
  return {startPos: start, endPos: end};
 }
 try {
  start = input.selectionStart;
  end = input.selectionEnd;
 } catch (e) {
 }
 return {startPos: start, endPos: end}; 
}
Selection.SetCaretPosition = function(input, caretPos) {
 if(typeof caretPos === "undefined" || caretPos < 0)
  caretPos = input.value.length;
 Selection.Set(input, caretPos, caretPos, true);
}
Selection.GetCaretPosition = function(element, isDialogMode) {
 var pos = 0;
 if("selectionStart" in element) {
  pos = element.selectionStart;
 } else if("selection" in document) {
  element.focus();
  var sel = document.selection.createRange(),
   selLength = document.selection.createRange().text.length;
  sel.moveStart("character", -element.value.length);
  pos = sel.text.length - selLength;
 }
 if(isDialogMode && !pos) {
  pos = element.value.length - 1;
 }
 return pos;
}
Selection.Clear = function() {
 try {
  if(window.getSelection) {
   window.getSelection().removeAllRanges();
  }
  else if(document.selection) {
   if(document.selection.empty)
    document.selection.empty();
   else if(document.selection.clear)
    document.selection.clear();
  }
 } catch(e) {
 }
}
Selection.ClearOnMouseMove = function(evt) {
 if(!Browser.IE || (evt.button != 0)) 
  Selection.Clear();
}
Selection.SetElementSelectionEnabled = function(element, value) {
 var userSelectValue = value ? "" : "none";
 var func = value ? Evt.DetachEventFromElement : Evt.AttachEventToElement;
 if(Browser.Firefox)
  element.style.MozUserSelect = userSelectValue;
 else if(Browser.WebKitFamily)
  element.style.webkitUserSelect = userSelectValue;
 else if(Browser.Opera)
  func(element, "mousemove", Selection.Clear);
 else {
  func(element, "selectstart", ASPx.FalseFunction);
  func(element, "mousemove", Selection.Clear);
 }
}
Selection.SetElementAsUnselectable = function(element, isWithChild, recursive) {
 if(element && element.nodeType == 1) {
  element.unselectable = "on";
  if(Browser.NetscapeFamily)
   element.onmousedown = ASPx.FalseFunction;
  if((Browser.IE && Browser.Version >= 9) || Browser.WebKitFamily)
   Evt.AttachEventToElement(element, "mousedown", Evt.PreventEventAndBubble);
  if(isWithChild === true){
   for(var j = 0; j < element.childNodes.length; j ++)
    Selection.SetElementAsUnselectable(element.childNodes[j], (!!recursive ? true : false), (!!recursive));
  }
 }
}
Selection.AreEqual = function(selection1, selection2) {
 return selection1.startPos === selection2.startPos && selection1.endPos === selection2.endPos;
}
ASPx.Selection = Selection;
var MouseScroller = { };
MouseScroller.MinimumOffset = 10;
MouseScroller.Create = function(getElement, getScrollXElement, getScrollYElement, needPreventScrolling, vertRecursive, onMouseDown, onMouseMove, onMouseUp, onMouseUpMissed) {
 var element = getElement();
 if(!element) 
  return;
 if(!element.dxMouseScroller)
  element.dxMouseScroller = new MouseScroller.Extender(getElement, getScrollXElement, getScrollYElement, needPreventScrolling, vertRecursive, onMouseDown, onMouseMove, onMouseUp, onMouseUpMissed);
 return element.dxMouseScroller;
}
MouseScroller.Extender = function(getElement, getScrollXElement, getScrollYElement, needPreventScrolling, vertRecursive, onMouseDown, onMouseMove, onMouseUp, onMouseUpMissed) {
 this.getElement = getElement;
 this.getScrollXElement = getScrollXElement;
 this.getScrollYElement = getScrollYElement;
 this.needPreventScrolling = needPreventScrolling;
 this.vertRecursive = !!vertRecursive;
 this.createHandlers(onMouseDown || function() { }, onMouseMove || function() { }, onMouseUp || function() { }, onMouseUpMissed || function() { });
 this.update()
};
MouseScroller.Extender.prototype = {
 update: function() {
  if(this.element)
   Evt.DetachEventFromElement(this.element, ASPx.TouchUIHelper.touchMouseDownEventName, this.mouseDownHandler);
  this.element = this.getElement();
  Evt.AttachEventToElement(this.element, ASPx.TouchUIHelper.touchMouseDownEventName, this.mouseDownHandler);  
  Evt.AttachEventToElement(this.element, "click", this.mouseClickHandler);   
  if(Browser.MSTouchUI && this.element.className.indexOf(ASPx.TouchUIHelper.msTouchDraggableClassName) < 0)
   this.element.className += " " + ASPx.TouchUIHelper.msTouchDraggableClassName;
  this.scrollXElement = this.getScrollXElement();
  this.scrollYElement = this.getScrollYElement();
 },
 createHandlers: function(onMouseDown, onMouseMove, onMouseUp, onMouseUpMissed) {
  var mouseDownCounter = 0;
  this.onMouseDown = onMouseDown;
  this.onMouseMove = onMouseMove;
  this.onMouseUp = onMouseUp;  
  this.mouseDownHandler = function(e) {
   if(mouseDownCounter++ > 0) {
    this.finishScrolling();
    onMouseUpMissed();
   }
   var eventSource = Evt.GetEventSource(e);
   var requirePreventCustonScroll = ASPx.IsExists(ASPx.TouchUIHelper.RequirePreventCustomScroll) && ASPx.TouchUIHelper.RequirePreventCustomScroll(eventSource, this.element);
   if(requirePreventCustonScroll || this.needPreventScrolling && this.needPreventScrolling(eventSource))
    return;
   this.scrollableTreeLine = this.GetScrollableElements();
   this.firstX = this.prevX = Evt.GetEventX(e);
   this.firstY = this.prevY = Evt.GetEventY(e);
   Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseMoveEventName, this.mouseMoveHandler);
   Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseUpEventName, this.mouseUpHandler);
   this.onMouseDown(e);
  }.aspxBind(this);
  this.mouseMoveHandler = function(e) {
   if(ASPx.TouchUIHelper.isGesture)
    return;
   var x = Evt.GetEventX(e);
   var y = Evt.GetEventY(e);
   var xDiff = this.prevX - x;
   var yDiff = this.prevY - y;
   if(this.vertRecursive) {
    var isTopDirection = yDiff < 0;
    this.scrollYElement = this.GetElementForVertScrolling(isTopDirection, this.prevIsTopDirection, this.scrollYElement);
    this.prevIsTopDirection = isTopDirection;
   }
   if(this.scrollXElement && xDiff != 0)
    this.scrollXElement.scrollLeft += xDiff;
   if(this.scrollYElement && yDiff != 0) {
    this.scrollYElement.scrollTop += yDiff;
    var isOuterScrollableElement = this.scrollableTreeLine[this.scrollableTreeLine.length - 1] == this.scrollYElement;
    if(isOuterScrollableElement)
     y += yDiff;
   }
   this.prevX = x;
   this.prevY = y;
   e.preventDefault();
   this.onMouseMove(e);
  }.aspxBind(this);
  this.mouseUpHandler = function(e) {
   this.finishScrolling();
   this.onMouseUp(e);
  }.aspxBind(this);
  this.mouseClickHandler = function(e){
   if(this.needPreventScrolling && this.needPreventScrolling(Evt.GetEventSource(e)))
    return;
   var xDiff = this.firstX - Evt.GetEventX(e);
   var yDiff = this.firstY - Evt.GetEventY(e);
   if(xDiff > MouseScroller.MinimumOffset || yDiff > MouseScroller.MinimumOffset)
    return Evt.PreventEventAndBubble(e);
  }.aspxBind(this);
  this.finishScrolling = function() {
   Evt.DetachEventFromDocument(ASPx.TouchUIHelper.touchMouseMoveEventName, this.mouseMoveHandler);
   Evt.DetachEventFromDocument(ASPx.TouchUIHelper.touchMouseUpEventName, this.mouseUpHandler);
   this.scrollableTreeLine = [];
   this.prevIsTopDirection = null;
   mouseDownCounter--;
  };
 },
 GetScrollableElements: function() {
  if(!this.vertRecursive) return [ ];
  var outerScrollableElementTag = ASPx.Browser.IE ? "HTML" : "BODY";
  return ASPx.GetElementTreeLine(this.element, null, function(el) { return el == document; })
   .filter(function(el) { return ASPx.IsScrollableElement(el, false, true) || el.tagName == outerScrollableElementTag }.bind(this));
 },
 GetElementForVertScrolling: function(currentIsTop, prevIsTop, prevElement) {
  if(prevElement && currentIsTop === prevIsTop && this.GetVertScrollExcess(prevElement, currentIsTop) > 0)
   return prevElement;
  for(var i = 0; i < this.scrollableTreeLine.length; i++) {
   var element = this.scrollableTreeLine[i];
   var excess = this.GetVertScrollExcess(element, currentIsTop);
   if(excess > 0)
    return element;
  }
  return null;
 },
 GetVertScrollExcess: function(element, isTop) {
  if(isTop)
   return element.scrollTop;
  var isBodyElement = element.tagName == "BODY";
  var clientHeight = isBodyElement ? ASPx.GetDocumentClientHeight() : element.clientHeight;
  return element.scrollHeight - clientHeight - element.scrollTop;
 }
}
ASPx.MouseScroller = MouseScroller;
var Evt = { };
Evt.GetEvent = function(evt){
 return (typeof(event) != "undefined" && event != null && Browser.IE) ? event : evt; 
}
Evt.IsEventPrevented = function(evt) {
 return evt.defaultPrevented || evt.returnValue === false;
}
Evt.PreventEvent = function(evt){
 if(evt.preventDefault)
  evt.preventDefault();
 else
  evt.returnValue = false;
 return false;
}
Evt.PreventEventAndBubble = function(evt){
 Evt.PreventEvent(evt);
 if(evt.stopPropagation)
  evt.stopPropagation();
 evt.cancelBubble = true;
 return false;
}
Evt.CancelBubble = function(evt){
 evt.cancelBubble = true;
 return false;
}
Evt.PreventImageDragging = function(image) {
 if(image) {
  if(Browser.NetscapeFamily)
   image.onmousedown = function(evt) {
    evt.cancelBubble = true;
    return false;
   };
  else
   image.ondragstart = function() {
    return false;
   };
 }
}
Evt.PreventDragStart = function(evt) {
 evt = Evt.GetEvent(evt);
 var element = Evt.GetEventSource(evt);
 if(element.releaseCapture)
  element.releaseCapture(); 
 return false;
}
Evt.PreventElementDrag = function(element) {
 if(Browser.IE)
  Evt.AttachEventToElement(element, "dragstart", Evt.PreventEvent);
 else
  Evt.AttachEventToElement(element, "mousedown", Evt.PreventEvent);
}
Evt.PreventElementDragAndSelect = function(element, skipMouseMove, skipIESelect){
 if(Browser.WebKitFamily)
  Evt.AttachEventToElement(element, "selectstart", Evt.PreventEventAndBubble);
 if(Browser.IE){
  if(!skipIESelect)
   Evt.AttachEventToElement(element, "selectstart", ASPx.FalseFunction);
  if(!skipMouseMove)
   Evt.AttachEventToElement(element, "mousemove", Selection.ClearOnMouseMove);
  Evt.AttachEventToElement(element, "dragstart", Evt.PreventDragStart);
 }
}
Evt.GetEventSource = function(evt){
 if(!ASPx.IsExists(evt)) return null; 
 return evt.srcElement ? evt.srcElement : evt.target;
}
Evt.GetKeyCode = function(srcEvt) {
 return Browser.NetscapeFamily || Browser.Opera ? srcEvt.which : srcEvt.keyCode;
}
function clientEventRequiresDocScrollCorrection() {
 var isSafariVerLess3 = Browser.Safari && Browser.Version < 3,
  isMacOSMobileVerLess51 = Browser.MacOSMobilePlatform && Browser.Version < 5.1;
 return Browser.AndroidDefaultBrowser || Browser.AndroidChromeBrowser || !(isSafariVerLess3 || isMacOSMobileVerLess51);
}
Evt.GetEventX = function(evt){
 if(ASPx.TouchUIHelper.isTouchEvent(evt))
  return ASPx.TouchUIHelper.getEventX(evt);
 return evt.clientX + (clientEventRequiresDocScrollCorrection() ? ASPx.GetDocumentScrollLeft() : 0);
}
Evt.GetEventY = function(evt){
 if(ASPx.TouchUIHelper.isTouchEvent(evt))
  return ASPx.TouchUIHelper.getEventY(evt);
 return evt.clientY + (clientEventRequiresDocScrollCorrection() ? ASPx.GetDocumentScrollTop() : 0 );
}
Evt.IsLeftButtonPressed = function(evt){
 if(ASPx.TouchUIHelper.isTouchEvent(evt)) 
  return true;
 evt = Evt.GetEvent(evt);
 if(!evt) return false;
 if(Browser.IE && Browser.Version < 11){
  if(Browser.MSTouchUI)
   return true;
  return evt.button % 2 == 1; 
 }
 else if(Browser.NetscapeFamily || Browser.WebKitFamily || (Browser.IE && Browser.Version >= 11) || Browser.Edge) {
  if(evt.type === "pointermove")
   return evt.buttons === 1;
  return evt.which == 1;
 }
 else if(Browser.Opera)
  return evt.button == 0;  
 return true;  
}
Evt.IsRightButtonPressed = function(evt){
 evt = Evt.GetEvent(evt);
 if(!ASPx.IsExists(evt)) return false;
 if(Browser.IE || Browser.Edge) {
  if(evt.type === "pointermove")
   return evt.buttons === 2;
  return evt.button == 2;
 }
 else if(Browser.NetscapeFamily || Browser.WebKitFamily)
  return evt.which == 3;
 else if (Browser.Opera)
  return evt.button == 1;
 return true;
}
Evt.GetWheelDelta = function(evt) {
 var ret;
 if(Browser.NetscapeFamily && Browser.MajorVersion < 17)
  ret = -evt.detail;
 else if(Browser.Safari)
  ret = evt.wheelDelta;
 else
  ret = -evt.deltaY;
 if(Browser.Opera && Browser.Version < 9)
  ret = -ret;
 return ret;
}
Evt.IsWheelEventWithDirection = function(evt) {
 return ASPx.Data.ArrayContains(["wheel", "mousewheel"], evt.type);
}
Evt.GetWheelDeltaX = function(evt) {
 if(evt.type === "wheel")
  return -evt.deltaX;
 if(evt.type === "mousewheel")
  return evt.wheelDeltaX;
}
Evt.GetWheelDeltaY = function(evt) {
 if(evt.type === "wheel")
  return -evt.deltaY;
 if(evt.type === "mousewheel")
  return evt.wheelDeltaY;
}
Evt.AttachEventToElement = function(element, eventName, func, onlyBubbling) {
 if(element.addEventListener)
  element.addEventListener(eventName, func, !onlyBubbling);
 else
  element.attachEvent("on" + eventName, func);
}
Evt.DetachEventFromElement = function(element, eventName, func) {
 if(element.removeEventListener)
  element.removeEventListener(eventName, func, true);
 else
  element.detachEvent("on" + eventName, func);
}
Evt.AttachEventToDocument = function(eventName, func) {
 var attachingAllowed = ASPx.TouchUIHelper.onEventAttachingToDocument(eventName, func);
 if(attachingAllowed)
  Evt.AttachEventToDocumentCore(eventName, func);
}
Evt.AttachEventToDocumentCore = function(eventName, func) {
 Evt.AttachEventToElement(document, eventName, func);
}
Evt.DetachEventFromDocument = function(eventName, func) {
 Evt.DetachEventFromDocumentCore(eventName, func);
 ASPx.TouchUIHelper.onEventDettachedFromDocument(eventName, func);
}
Evt.DetachEventFromDocumentCore = function(eventName, func){
 Evt.DetachEventFromElement(document, eventName, func);
}
Evt.GetMouseWheelEventName = function() {
 if(Browser.Safari)
  return "mousewheel";
 if(Browser.NetscapeFamily && Browser.MajorVersion < 17)
  return "DOMMouseScroll";
 return "wheel";
}
Evt.AttachMouseEnterToElement = function (element, onMouseOverHandler, onMouseOutHandler) {
 Evt.AttachEventToElement(element, ASPx.TouchUIHelper.pointerEnabled ? ASPx.TouchUIHelper.pointerOverEventName : "mouseover", function (evt) { mouseEnterHandler(evt, element, onMouseOverHandler, onMouseOutHandler); });
 Evt.AttachEventToElement(element, ASPx.TouchUIHelper.pointerEnabled ? ASPx.TouchUIHelper.pointerOutEventName : "mouseout", function (evt) { mouseEnterHandler(evt, element, onMouseOverHandler, onMouseOutHandler); });
}
Evt.GetEventRelatedTarget = function(evt, isMouseOverEvent) {
 return evt.relatedTarget || (isMouseOverEvent ? evt.srcElement : evt.toElement);
}
function mouseEnterHandler(evt, element, onMouseOverHandler, onMouseOutHandler) {
 var isMouseOverExecuted = !!element.dxMouseOverExecuted;
 var isMouseOverEvent = (evt.type == "mouseover" || evt.type == ASPx.TouchUIHelper.pointerOverEventName);
 if(isMouseOverEvent && isMouseOverExecuted || !isMouseOverEvent && !isMouseOverExecuted)
  return;
 var source = Evt.GetEventRelatedTarget(evt, isMouseOverEvent);
 if(!ASPx.GetIsParent(element, source)) {
  element.dxMouseOverExecuted = isMouseOverEvent;
  if(isMouseOverEvent)
   onMouseOverHandler(element);
  else
   onMouseOutHandler(element);
 }
 else if(isMouseOverEvent && !isMouseOverExecuted) {
  element.dxMouseOverExecuted = true;
  onMouseOverHandler(element);
 }
}
Evt.DispatchEvent = function(target, eventName, canBubble, cancellable) {
 var event;
 if(Browser.IE && Browser.Version < 9) {
  eventName = "on" + eventName;
  if(eventName in target) {
   event = document.createEventObject();
   target.fireEvent("on" + eventName, event);
  }
 } else {
  event = document.createEvent("Event");
  event.initEvent(eventName, canBubble || false, cancellable || false);
  target.dispatchEvent(event);
 }
}
Evt.EmulateDocumentOnMouseDown = function(evt) {
 Evt.EmulateOnMouseDown(document, evt);
}
Evt.EmulateOnMouseDown = function(element, evt) {
 if(Browser.IE && Browser.Version < 9)
  element.fireEvent("onmousedown", evt);
 else if(!Browser.WebKitFamily){
  var emulatedEvt = document.createEvent("MouseEvents");
  emulatedEvt.initMouseEvent("mousedown", true, true, window, 0, evt.screenX, evt.screenY, 
   evt.clientX, evt.clientY, evt.ctrlKey, evt.altKey, evt.shiftKey, false, 0, null);
  element.dispatchEvent(emulatedEvt);
 }
}
Evt.EmulateOnMouseEvent = function (type, element, evt) {
 evt.type = type;
 var emulatedEvt = document.createEvent("MouseEvents");
 emulatedEvt.initMouseEvent(type, true, true, window, 0, evt.screenX, evt.screenY,
  evt.clientX, evt.clientY, evt.ctrlKey, evt.altKey, evt.shiftKey, false, 0, null);
 emulatedEvt.target = element;
 element.dispatchEvent(emulatedEvt);
}
Evt.EmulateMouseClick = function (element, evt) {
 var x = element.offsetWidth / 2;
 var y = element.offsetHeight / 2;
 if (!evt)
  evt = {
   bubbles: true,
   cancelable: true,
   view: window,
   detail: 1,
   screenX: 0,
   screenY: 0,
   clientX: x,
   clientY: y,
   ctrlKey: false,
   altKey: false,
   shiftKey: false,
   metaKey: false,
   button: 0,
   relatedTarget: null
  };
 Evt.EmulateOnMouseEvent("mousedown", element, evt);
 Evt.EmulateOnMouseEvent("mouseup", element, evt);
 Evt.EmulateOnMouseEvent("click", element, evt);
}
Evt.DoElementClick = function(element) {
 try{
  element.click();
 }
 catch(e){ 
 }
}
Evt.IsActionKeyPressed = function(evt) {
 return evt.keyCode === ASPx.Key.Space ||
     evt.keyCode === ASPx.Key.Enter ||
    (evt.keyCode === ASPx.Key.Down && evt.altKey);
}
Evt.InvokeMouseClickByKeyDown = function(evt, handler) {
 if(Evt.IsActionKeyPressed(evt)) {
  ASPx.Evt.PreventEvent(evt); 
  if(!handler)
   ASPx.Evt.GetEventSource(evt).onclick();
  else
   handler(evt);
 }
}
ASPx.Evt = Evt;
var Attr = { };
Attr.GetAttribute = function(obj, attrName){
 if(obj.getAttribute)
  return obj.getAttribute(attrName);
 else if(obj.getPropertyValue)
  return obj.getPropertyValue(attrName);
 return null;
}
Attr.SetAttribute = function(obj, attrName, value){
 if(obj.setAttribute) {
  if(Browser.IE && Browser.MajorVersion >= 11 && attrName.toLowerCase() === "src") 
   obj.setAttribute(attrName, "");
  obj.setAttribute(attrName, value);
 } else if(obj.setProperty)
  obj.setProperty(attrName, value, "");
}
Attr.RemoveAttribute = function(obj, attrName){
 if(obj.removeAttribute)
  obj.removeAttribute(attrName);
 else if(obj.removeProperty)
  obj.removeProperty(attrName);
}
Attr.IsExistsAttribute = function(obj, attrName){
 var value = Attr.GetAttribute(obj, attrName);
 return (value != null) && (value !== "");
}
Attr.SetOrRemoveAttribute = function(obj, attrName, value) {
 if(!value)
  Attr.RemoveAttribute(obj, attrName);
 else
  Attr.SetAttribute(obj, attrName, value);
}
Attr.SaveAttribute = function(obj, attrName, savedObj, savedAttrName){
 if(!Attr.IsExistsAttribute(savedObj, savedAttrName)){
  var oldValue = Attr.IsExistsAttribute(obj, attrName) ? Attr.GetAttribute(obj, attrName) : ASPx.EmptyObject;
  Attr.SetAttribute(savedObj, savedAttrName, oldValue);
 }
}
Attr.SaveStyleAttribute = function(obj, attrName){
 Attr.SaveAttribute(obj.style, attrName, obj, "saved" + attrName);
}
Attr.ChangeAttributeExtended = function(obj, attrName, savedObj, savedAttrName, newValue){
 Attr.SaveAttribute(obj, attrName, savedObj, savedAttrName);
 Attr.SetAttribute(obj, attrName, newValue);
}
Attr.ChangeAttribute = function(obj, attrName, newValue){
 Attr.ChangeAttributeExtended(obj, attrName, obj, "saved" + attrName, newValue);
}
Attr.ChangeStyleAttribute = function(obj, attrName, newValue){
 Attr.ChangeAttributeExtended(obj.style, attrName, obj, "saved" + attrName, newValue);
}
Attr.ResetAttributeExtended = function(obj, attrName, savedObj, savedAttrName){
 Attr.SaveAttribute(obj, attrName, savedObj, savedAttrName);
 Attr.SetAttribute(obj, attrName, "");
 Attr.RemoveAttribute(obj, attrName);
}
Attr.ResetAttribute = function(obj, attrName){
 Attr.ResetAttributeExtended(obj, attrName, obj, "saved" + attrName);
}
Attr.ResetStyleAttribute = function(obj, attrName){
 Attr.ResetAttributeExtended(obj.style, attrName, obj, "saved" + attrName);
}
Attr.RestoreAttributeExtended = function(obj, attrName, savedObj, savedAttrName){
 if(Attr.IsExistsAttribute(savedObj, savedAttrName)){
  var oldValue = Attr.GetAttribute(savedObj, savedAttrName);
  if(oldValue != ASPx.EmptyObject)
   Attr.SetAttribute(obj, attrName, oldValue);
  else
   Attr.RemoveAttribute(obj, attrName);
  Attr.RemoveAttribute(savedObj, savedAttrName);
  return true;
 }
 return false;
}
Attr.RestoreAttribute = function(obj, attrName){
 return Attr.RestoreAttributeExtended(obj, attrName, obj, "saved" + attrName);
}
Attr.RestoreStyleAttribute = function(obj, attrName){
 return Attr.RestoreAttributeExtended(obj.style, attrName, obj, "saved" + attrName);
}
Attr.CopyAllAttributes = function(sourceElem, destElement) {
 var attrs = sourceElem.attributes;
 for(var n = 0; n < attrs.length; n++) {
  var attr = attrs[n];
  if(attr.specified) {
   var attrName = attr.nodeName;
   var attrValue = sourceElem.getAttribute(attrName, 2);
   if(attrValue == null)
    attrValue = attr.nodeValue;
   destElement.setAttribute(attrName, attrValue, 0); 
  }
 }
 if(sourceElem.style.cssText !== '')
  destElement.style.cssText = sourceElem.style.cssText;
}
Attr.RemoveAllAttributes = function(element, excludedAttributes) {
 var excludedAttributesHashTable = {};
 if(excludedAttributes)
  excludedAttributesHashTable = Data.CreateHashTableFromArray(excludedAttributes);
 if(element.attributes) {
  var attrArray = element.attributes;
  for(var i = 0; i < attrArray.length; i++) {
   var attrName = attrArray[i].name;
   if(!ASPx.IsExists(excludedAttributesHashTable[attrName.toLowerCase()])) {
    try {
     attrArray.removeNamedItem(attrName);
    } catch (e) { }
   }
  }
 }
}
Attr.RemoveStyleAttribute = function(element, attrName) {
 if(element.style) {
  if(Browser.Firefox && element.style[attrName]) 
   element.style[attrName] = "";
  if(element.style.removeAttribute && element.style.removeAttribute != "")
   element.style.removeAttribute(attrName);
  else if(element.style.removeProperty && element.style.removeProperty != "")
   element.style.removeProperty(attrName);
 }
}
Attr.RemoveAllStyles = function(element) {
 if(element.style) {
  for(var key in element.style)
   Attr.RemoveStyleAttribute(element, key);
    Attr.RemoveAttribute(element, "style");
 }
}
Attr.GetTabIndexAttributeName = function(){
 return Browser.IE  ? "tabIndex" : "tabindex";
}
Attr.ChangeTabIndexAttribute = function(element){
 var attribute = Attr.GetTabIndexAttributeName(); 
 if(Attr.GetAttribute(element, attribute) != -1)
    Attr.ChangeAttribute(element, attribute, -1);
}
Attr.SaveTabIndexAttributeAndReset = function(element) {
 var attribute = Attr.GetTabIndexAttributeName();
 Attr.SaveAttribute(element, attribute, element, "saved" + attribute);
 Attr.SetAttribute(element, attribute, -1);
}
Attr.RestoreTabIndexAttribute = function(element){
 var attribute = Attr.GetTabIndexAttributeName();
 if(Attr.IsExistsAttribute(element, attribute)) {
  if(Attr.GetAttribute(element, attribute) == -1) {
   if(Attr.IsExistsAttribute(element, "saved" + attribute)){
    var oldValue = Attr.GetAttribute(element, "saved" + attribute);
    if(oldValue != ASPx.EmptyObject)
     Attr.SetAttribute(element, attribute, oldValue);
    else {
     if(Browser.WebKitFamily) 
      Attr.SetAttribute(element, attribute, 0); 
     Attr.RemoveAttribute(element, attribute);   
    }
    Attr.RemoveAttribute(element, "saved" + attribute); 
   }
  }
 }
}
Attr.ChangeAttributesMethod = function(enabled){
 return enabled ? Attr.RestoreAttribute : Attr.ResetAttribute;
}
Attr.InitiallyChangeAttributesMethod = function(enabled){
 return enabled ? Attr.ChangeAttribute : Attr.ResetAttribute;
}
Attr.ChangeStyleAttributesMethod = function(enabled){
 return enabled ? Attr.RestoreStyleAttribute : Attr.ResetStyleAttribute;
}
Attr.InitiallyChangeStyleAttributesMethod = function(enabled){
 return enabled ? Attr.ChangeStyleAttribute : Attr.ResetStyleAttribute;
}
Attr.ChangeEventsMethod = function(enabled){
 return enabled ? Evt.AttachEventToElement : Evt.DetachEventFromElement;
}
Attr.ChangeDocumentEventsMethod = function(enabled){
 return enabled ? Evt.AttachEventToDocument : Evt.DetachEventFromDocument;
}
Attr.ChangeCellSpanCount = function(cell, value, isColumnSpan) {
 if(!cell) return;
 var propertyKey = isColumnSpan ? "colSpan" : "rowSpan";
 var prevValue = cell[propertyKey];
 if(value > 1)
  cell[propertyKey] = value;
 else if(prevValue !== 1)
  Attr.RemoveAttribute(cell, propertyKey);
}
ASPx.Attr = Attr;
var Aria = {
 atomic: "aria-atomic",
 checked: "aria-checked",
 descendant: "aria-activedescendant",
 described: "aria-describedby",
 disabled: "aria-disabled",
 expanded: "aria-expanded",
 haspopup: "aria-haspopup",
 invalid: "aria-invalid",
 label: "aria-label",
 labelled: "aria-labelledby",
 level: "aria-level",
 owns: "aria-owns",
 posinset: "aria-posinset",
 role: "role",
 selected: "aria-selected",
 setsize: "aria-setsize",
 valuemax: "aria-valuemax",
 valuemin: "aria-valuemin",
 valuenow: "aria-valuenow"
};
Aria.SetOrRemoveDescendant = function(obj, value) {
 ASPx.Attr.SetOrRemoveAttribute(obj, Aria.descendant, value);
}
Aria.SetOrRemoveLabel = function(obj, value) {
 ASPx.Attr.SetOrRemoveAttribute(obj, Aria.label, value);
}
Aria.SetOrRemoveLabelled = function(obj, value) {
 ASPx.Attr.SetOrRemoveAttribute(obj, Aria.labelled, value);
}
Aria.SetApplicationRole = function(obj) {
  ASPx.Attr.SetAttribute(obj, Aria.role, "application");
}
Aria.SetSilence = function(obj) {
 ASPx.Attr.SetAttribute(obj, Aria.label, ";");
}
Aria.SetExpanded = function(obj, expanded) {
 if(!obj || !ASPx.Attr.GetAttribute(obj, Aria.expanded)) return;
 Aria.SetBoolAttribute(obj, Aria.expanded, expanded);
}
Aria.SetAtomic = function(obj, value) {
 Aria.SetBoolAttribute(obj, Aria.atomic, value);
}
Aria.SetBoolAttribute = function(obj, attribute, value) {
 if(value)
  ASPx.Attr.SetAttribute(obj, attribute, true);
 else 
  ASPx.Attr.SetAttribute(obj, attribute, false);
}
ASPx.Attr.Aria = Aria;
var Color = { };
function _aspxToHex(d) {
 return (d < 16) ? ("0" + d.toString(16)) : d.toString(16);
}
Color.ColorToHexadecimal = function(colorValue) {
 if(typeof(colorValue) == "number") {
  var r = colorValue & 0xFF;
  var g = (colorValue >> 8) & 0xFF;
  var b = (colorValue >> 16) & 0xFF;
  return "#" + _aspxToHex(r) + _aspxToHex(g) + _aspxToHex(b);
 }
 if(colorValue && (colorValue.substr(0, 3).toLowerCase() == "rgb")) {
  var re = /rgb\s*\(\s*([0-9]+)\s*,\s*([0-9]+)\s*,\s*([0-9]+)\s*\)/;
  var regResult = colorValue.toLowerCase().match(re);
  if(regResult) {
   var r = parseInt(regResult[1]);
   var g = parseInt(regResult[2]);
   var b = parseInt(regResult[3]);
   return "#" + _aspxToHex(r) + _aspxToHex(g) + _aspxToHex(b);
  }
  return null;
 } 
 if(colorValue && (colorValue.charAt(0) == "#"))
  return colorValue;
 return null;
}
Color.Names = {
 AddColorNames: function(stringResourcesObj) {
  if(stringResourcesObj) {
   for(var key in stringResourcesObj)
    this[key] = stringResourcesObj[key];
  }
 }
}
ASPx.Color = Color;
var Url = { };
Url.Navigate = function(url, target) {
 var javascriptPrefix = "javascript:";
 if(!url || url === "")
  return;
 else if(url.indexOf(javascriptPrefix) != -1) 
  eval(url.substr(javascriptPrefix.length));
 else {
  try{
   if(target != "")
    navigateTo(url, target);
   else
    location.href = url;
  }
  catch(e){
  }
 }
}
Url.NavigateByLink = function(linkElement) {
 Url.Navigate(Attr.GetAttribute(linkElement, "href"), linkElement.target);
}
Url.GetAbsoluteUrl = function(url) {
 if(url)
  url = Url.getURLObject(url).href;
 return url;
}
var absolutePathPrefixes = 
 [ "about:", "file:///", "ftp://", "gopher://", "http://", "https://", "javascript:", "mailto:", "news:", "res://", "telnet://", "view-source:" ];
Url.isAbsoluteUrl = function(url) {
 if (url) {
  for (var i = 0; i < absolutePathPrefixes.length; i++) {
   if(url.indexOf(absolutePathPrefixes[i]) == 0)
    return true;
  }
 }
 return false;
}
Url.getURLObject = function(url) {
 var link = document.createElement('A');
 link.href = url || "";
 return { 
  href: link.href,
  protocol: link.protocol,
  host: link.host,
  port: link.port,
  pathname: link.pathname,
  search: link.search,
  hash: link.hash
 }; 
}
Url.getRootRelativeUrl = function(url) {
 return getRelativeUrl(url, !Url.isRootRelativeUrl(url), true); 
}
Url.getPathRelativeUrl = function(url) {
 return getRelativeUrl(url, !Url.isPathRelativeUrl(url), false);
}
function getRelativeUrl(url, isValid, isRootRelative) {
 if(url && !(/data:([^;]+\/?[^;]*)(;charset=[^;]*)?(;base64,)/.test(url)) && isValid) {
  var urlObject = Url.getURLObject(url);
  var baseUrlObject = Url.getURLObject();
  if(!Url.isAbsoluteUrl(url) || urlObject.host === baseUrlObject.host && urlObject.protocol === baseUrlObject.protocol) {
   url = urlObject.pathname;
   if(!isRootRelative)
    url = getPathRelativeUrl(baseUrlObject.pathname, url);
   url = url + urlObject.search + urlObject.hash;
  }
 }
 return url;   
}
function getPathRelativeUrl(baseUrl, url) {
 var requestSegments = getSegments(baseUrl, false);
 var urlSegments = getSegments(url, true);
 return buildPathRelativeUrl(requestSegments, urlSegments, 0, 0, "");
}
function getSegments(url, addTail) {
 var segments = [];
 var startIndex = 0;
 var endIndex = -1;
 while ((endIndex = url.indexOf("/", startIndex)) != -1) {
  segments.push(url.substring(startIndex, ++endIndex));
  startIndex = endIndex;
 }
 if(addTail && startIndex < url.length)
  segments.push(url.substring(startIndex, url.length)); 
 return segments;
}
function buildPathRelativeUrl(requestSegments, urlSegments, reqIndex, urlIndex, buffer) {
 if(urlIndex >= urlSegments.length)
  return buffer;
 if(reqIndex >= requestSegments.length)
  return buildPathRelativeUrl(requestSegments, urlSegments, reqIndex, urlIndex + 1, buffer + urlSegments[urlIndex]);
 if(requestSegments[reqIndex] === urlSegments[urlIndex] && urlIndex === reqIndex)
  return buildPathRelativeUrl(requestSegments, urlSegments, reqIndex + 1, urlIndex + 1, buffer);
 return buildPathRelativeUrl(requestSegments, urlSegments, reqIndex + 1, urlIndex, buffer + "../");
}
Url.isPathRelativeUrl = function(url) {
 return !!url && !Url.isAbsoluteUrl(url) && url.indexOf("/") != 0;  
}
Url.isRootRelativeUrl = function(url) {
 return !!url && !Url.isAbsoluteUrl(url) && url.indexOf("/") == 0 && url.indexOf("//") != 0;
}
function navigateTo(url, target) {
 var lowerCaseTarget = target.toLowerCase();
 if("_top" == lowerCaseTarget)
  top.location.href = url;
 else if("_self" == lowerCaseTarget)
  location.href = url;
 else if("_search" == lowerCaseTarget)
  openInNewWindow(url)
 else if("_media" == lowerCaseTarget)
  openInNewWindow(url)
 else if("_parent" == lowerCaseTarget)
  window.parent.location.href = url;
 else if("_blank" == lowerCaseTarget)
  openInNewWindow(url)
 else {
  var frame = getFrame(top.frames, target);
  if(frame != null)
   frame.location.href = url;
  else
   openInNewWindow(url)
 }
}
function openInNewWindow(url) {
 if(ASPx.Browser.Safari)
  openInNewWindowViaIframe(url);
 else {
  var newWindow = window.open();
  newWindow.opener = null;
  newWindow.location = url;
 }
}
function openInNewWindowViaIframe(url) {
 var iframe = document.createElement('iframe');
 iframe.style.display = 'none';
 document.body.appendChild(iframe);
 var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
 var openArgs = '"' + url + '"';
 var script = iframeDoc.createElement('script');
 script.type = 'text/javascript';
 script.text = 'window.parent = null; ' +
  'window.top = null;' +
  'window.frameElement = null;' +
  'var child = window.open(' + openArgs + ');' +
  'child.opener = null';
 iframeDoc.body.appendChild(script);
 document.body.removeChild(iframe);
}
ASPx.Url = Url;
var Office = {}
Office.getHandlerResourceUrl = function(pageUrl) {
 var url = pageUrl ? pageUrl : document.URL;
 if(url.indexOf("?") != -1)
  url = url.substring(0, url.indexOf("?"));
 if(url.indexOf("#") != -1) 
  url = url.substring(0, url.indexOf("#"));
 if(/.*\.aspx$/.test(url))
  url = url.substring(0, url.lastIndexOf("/") + 1);
 else if(url.lastIndexOf("/") != url.length - 1)
  url += "/";
 return url;
}
ASPx.Office = Office;
var Json = { };
function isValid(JsonString) {
 return !(/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(JsonString.replace(/"(\\.|[^"\\])*"/g, '')))
}
Json.Eval = function(jsonString, controlName) {
 if(isValid(jsonString))
  return eval("(" + jsonString + ")");
 else
  throw new Error(controlName + " received incorrect JSON-data: " + jsonString);
}
Json.ToJson = function(param){
 var paramType = typeof(param);
 if((paramType == "undefined") || (param == null))
  return null;
 if((paramType == "object") && (typeof(param.__toJson) == "function"))
  return param.__toJson();
 if((paramType == "number") || (paramType == "boolean"))
  return param;
 if(param.constructor == Date)
  return dateToJson(param);
 if(paramType == "string") {
  var result = param.replace(/\\/g, "\\\\");
  result = result.replace(/"/g, "\\\"");
  result = result.replace(/\n/g, "\\n");
  result = result.replace(/\r/g, "\\r");
  result = result.replace(/</g, "\\u003c");
  result = result.replace(/>/g, "\\u003e");
  return "\"" + result + "\"";
 }
 if(param.constructor == Array){
  var values = [];
  for(var i = 0; i < param.length; i++) {
   var jsonValue = Json.ToJson(param[i]);
   if(jsonValue === null)
    jsonValue = "null";
   values.push(jsonValue);
  }
  return "[" + values.join(",") + "]";
 }
 var exceptKeys = {};
 if(ASPx.Ident.IsArray(param.__toJsonExceptKeys))
  exceptKeys = Data.CreateHashTableFromArray(param.__toJsonExceptKeys);
 exceptKeys["__toJsonExceptKeys"] = 1;
 var values = [];
 for(var key in param){
  if(ASPx.IsFunction(param[key]))
   continue;
  if(exceptKeys[key] == 1)
   continue;
  values.push(Json.ToJson(key) + ":" + Json.ToJson(param[key]));
 }
 return "{" + values.join(",") + "}";
}
function dateToJson(date) {
 var result = [ 
  date.getFullYear(),
  date.getMonth(),
  date.getDate()
 ];
 var time = {
  h: date.getHours(),
  m: date.getMinutes(),
  s: date.getSeconds(),
  ms: date.getMilliseconds()
 };
 if(time.h || time.m || time.s || time.ms)
  result.push(time.h);
 if(time.m || time.s || time.ms)
  result.push(time.m);
 if(time.s || time.ms)
  result.push(time.s);
 if(time.ms)
  result.push(time.ms);
 return "new Date(" + result.join() + ")";
}
ASPx.Json = Json;
ASPx.CreateClass = function(parentClass, properties) {
 var ret = function() {
  if(ret.preparing) 
   return delete(ret.preparing);
  if(ret.constr) {
   this.constructor = ret;
   ret.constr.apply(this, arguments);
  }
 }
 ret.prototype = {};
 if(parentClass) {
  parentClass.preparing = true;
  for(var name in parentClass) {
   if(parentClass.hasOwnProperty(name) && name != 'constr' && ASPx.IsFunction(parentClass[name]) && !ret[name])
    ret[name] = parentClass[name].aspxBind(parentClass);
  }
  ret.prototype = new parentClass;
  ret.prototype.constructor = parentClass;
  ret.constr = parentClass;
 }
 if(properties) {
  var constructorName = "constructor";
  for(var name in properties){
   if(name != constructorName) 
    ret.prototype[name] = properties[name];
  }
  if(properties[constructorName] && properties[constructorName] != Object)
   ret.constr = properties[constructorName];
 }
 return ret;
}
ASPx.FormatCallbackArg = function(prefix, arg) {
 if(prefix == null && arg == null)
  return ""; 
 if(prefix == null) prefix = "";
 if(arg == null) arg = "";
 if(arg != null && !ASPx.IsExists(arg.length) && ASPx.IsExists(arg.value))
  arg = arg.value;
 arg = arg.toString();
 return [prefix, '|', arg.length, '|' , arg].join('');
}
ASPx.FormatCallbackArgs = function(callbackData) {
 var sb = [ ];
 for(var i = 0; i < callbackData.length; i++)
  sb.push(ASPx.FormatCallbackArg(callbackData[i][0], callbackData[i][1]));
 return sb.join("");
}
ASPx.ParseShortcutString = function(shortcutString) {
 if(!shortcutString)
  return 0;
 var isCtrlKey = false;
 var isShiftKey = false;
 var isAltKey = false;
 var isMetaKey = false;
 var keyCode = null;
 var shcKeys = shortcutString.toString().split("+");
 if(shcKeys.length > 0) {
  for(var i = 0; i < shcKeys.length; i++) {
   var key = Str.Trim(shcKeys[i].toUpperCase());
   switch (key) {
    case "CTRL":
     isCtrlKey = true;
     break;
    case "SHIFT":
     isShiftKey = true;
     break;
    case "ALT":
     isAltKey = true;
     break;
    case "CMD":
     isMetaKey = true;
     break;
    case "F1": keyCode = ASPx.Key.F1; break;
    case "F2": keyCode = ASPx.Key.F2; break;
    case "F3": keyCode = ASPx.Key.F3; break;
    case "F4": keyCode = ASPx.Key.F4; break;
    case "F5": keyCode = ASPx.Key.F5; break;
    case "F6": keyCode = ASPx.Key.F6; break;
    case "F7": keyCode = ASPx.Key.F7; break;
    case "F8": keyCode = ASPx.Key.F8; break;
    case "F9": keyCode = ASPx.Key.F9; break;
    case "F10":   keyCode = ASPx.Key.F10; break;
    case "F11":   keyCode = ASPx.Key.F11; break;
    case "F12":   keyCode = ASPx.Key.F12; break;
    case "ENTER": keyCode = ASPx.Key.Enter; break;
    case "HOME":  keyCode = ASPx.Key.Home; break;
    case "END":   keyCode = ASPx.Key.End; break;
    case "LEFT":  keyCode = ASPx.Key.Left; break;
    case "RIGHT": keyCode = ASPx.Key.Right; break;
    case "UP": keyCode = ASPx.Key.Up; break;
    case "DOWN":  keyCode = ASPx.Key.Down; break;
    case "PAGEUP": keyCode = ASPx.Key.PageUp; break;
    case "PAGEDOWN": keyCode = ASPx.Key.PageDown; break;
    case "SPACE": keyCode = ASPx.Key.Space; break;
    case "TAB":   keyCode = ASPx.Key.Tab; break;
    case "BACK":  keyCode = ASPx.Key.Backspace; break;
    case "CONTEXT": keyCode = ASPx.Key.ContextMenu; break;
    case "ESCAPE":
    case "ESC":
     keyCode = ASPx.Key.Esc;
     break;
    case "DELETE":
    case "DEL":
     keyCode = ASPx.Key.Delete;
     break;
    case "INSERT":
    case "INS":
     keyCode = ASPx.Key.Insert;
     break;
    case "PLUS":
     keyCode = "+".charCodeAt(0);
     break;
    default:
     keyCode = key.charCodeAt(0);
     break;
   }
  }
 } else
  ASPx.ShowErrorAlert("Invalid shortcut");
 return ASPx.GetShortcutCode(keyCode, isCtrlKey, isShiftKey, isAltKey, isMetaKey);
}
ASPx.GetShortcutCode = function(keyCode, isCtrlKey, isShiftKey, isAltKey, isMetaKey) {
 var value = keyCode & 0xFFFF;
 var flags = 0;
 flags |= isCtrlKey ? 1 << 0 : 0;
 flags |= isShiftKey ? 1 << 2 : 0;
 flags |= isAltKey ? 1 << 4 : 0;
 flags |= isMetaKey ? 1 << 8 : 0;
 value |= flags << 16;
 return value;
}
ASPx.GetShortcutCodeByEvent = function(evt) {
 return ASPx.GetShortcutCode(Evt.GetKeyCode(evt), evt.ctrlKey, evt.shiftKey, evt.altKey, ASPx.Browser.MacOSPlatform ? evt.metaKey : false);
}
ASPx.IsPasteShortcut = function(evt) {
 if(evt.type === "paste")
  return true;
 var keyCode = Evt.GetKeyCode(evt);
 if(Browser.NetscapeFamily && evt.which == 0)  
  keyCode = evt.keyCode;
 return (evt.ctrlKey && (keyCode == 118  || (keyCode == 86))) ||
     (evt.shiftKey && !evt.ctrlKey && !evt.altKey &&
     (keyCode == ASPx.Key.Insert)) ;
}
ASPx.SetFocus = function(element, selectAction) {
 function focusCore(element, selectAction){
  try {
    element.focus();
    if(Browser.IE && document.activeElement != element)
     element.focus();
    if(selectAction) {
     var currentSelection = Selection.GetInfo(element);
     if(currentSelection.startPos == currentSelection.endPos) {
      switch(selectAction) {
       case "start":
        Selection.SetCaretPosition(element, 0);
        break;
       case "all":
        Selection.Set(element);
        break;
      }
     }
    }
   } catch (e) {
  }
 }
 if(ASPxClientUtils.iOSPlatform) 
  focusCore(element, selectAction);
 else {
  window.setTimeout(function() { 
   focusCore(element, selectAction);
  }, 100);
 }
}
ASPx.IsFocusableCore = function(element, skipContainerVisibilityCheck) {
 var current = element;
 while(current && current.nodeType == 1) {
  if(current == element || !skipContainerVisibilityCheck(current)) {
   if(current.tagName == "BODY")
    return true;
   if(current.disabled || !ASPx.GetElementDisplay(current) || !ASPx.GetElementVisibility(current))
    return false;
  }
  current = current.parentNode;
 }
 return true;
}
ASPx.IsFocusable = function(element) {
 return ASPx.IsFocusableCore(element, ASPx.FalseFunction);
}
ASPx.IsActionElement = function(element) {
 if(!ASPx.IsExistsElement(element))
  return false;
 var tabIndex = parseInt(ASPx.Attr.GetAttribute(element, ASPx.Attr.GetTabIndexAttributeName()));
 var hasTabIndex = !isNaN(tabIndex);
 var hasNonNegativeTabIndex = hasTabIndex && tabIndex > -1;
 var hasNegativeTabIndex = hasTabIndex && tabIndex < 0;
 var tagName = element.tagName;
 var focusableElementTags = ["BUTTON", "SELECT", "TEXTAREA", "OPTION", "IFRAME"];
 var isFocusableCore = ASPx.IsFocusable(element);
 var isFocusableTag = focusableElementTags.indexOf(tagName) !== -1;
 var isFocusableLink = tagName === "A" && (!!element.href || hasNonNegativeTabIndex);
 var isFocusableInput = tagName === "INPUT" && element.type.toLowerCase() !== "hidden";
 var isFocusableByTabIndex = tagName !== "INPUT" && hasNonNegativeTabIndex;
 return isFocusableCore && !hasNegativeTabIndex && (isFocusableTag || isFocusableLink || isFocusableInput || isFocusableByTabIndex);
};
ASPx.GetCanBeActiveElementsInContainer = function(container) {
 var canBeActiveTags = ["INPUT", "A", "UL", "BUTTON", "TEXTAREA", "SELECT", "IFRAME"],
  canBeActiveElements = [];
 Data.ForEach(canBeActiveTags, function(tag) {
  var elements = container.getElementsByTagName(tag);
  canBeActiveElements = canBeActiveElements.concat([].slice.call(elements));
 });
 return canBeActiveElements;
};
function isActionElementAllowedByPredicate(element, predicate) {
  var allowedByPredicate = !predicate || predicate(element);
  return allowedByPredicate && ASPx.IsActionElement(element);
}
ASPx.FindChildActionElements = function(container, predicate) {
 return ASPx.GetNodes(container, function(el) {
  return isActionElementAllowedByPredicate(el, predicate);
 });
}
ASPx.FindAllSortedActionElements = function(container, predicate) {
 var result = [ ];
 if(!container || !container.getElementsByTagName) return result;
 var actionElements = ASPx.FindChildActionElements(container, predicate);
 var getTabOrderValue = function(el) {
  var tabIndex = parseInt(ASPx.Attr.GetAttribute(el, ASPx.Attr.GetTabIndexAttributeName()));
  return isNaN(tabIndex) ? 0 : tabIndex;
 }
 var positiveTabIndexElements = actionElements.filter(function(x) { return getTabOrderValue(x) > 0; });
 var nonPositiveTabIndexElements = actionElements.filter(function(x) { return getTabOrderValue(x) === 0; });
 var sortedTabIndexElements = positiveTabIndexElements.sort(function(x, y) { return getTabOrderValue(x) - getTabOrderValue(y); });
 result = sortedTabIndexElements.concat(nonPositiveTabIndexElements);
 return result;
}
ASPx.FindFirstChildActionElement = function(container, predicate) {
 if(!container || isActionElementAllowedByPredicate(container, predicate))
  return !container ? null : container;
 var sortedActionElements = ASPx.FindAllSortedActionElements(container, predicate);
 return sortedActionElements[0];
}
ASPx.FindLastChildActionElement = function(container, predicate) {
 if(!container)
  return null;
 var sortedActionElements = ASPx.FindAllSortedActionElements(container, predicate);
 var actionElement = sortedActionElements[sortedActionElements.length - 1];
 if(!actionElement && isActionElementAllowedByPredicate(container, predicate))
  actionElement = container;
 return actionElement;
}
ASPx.GetParentClientControls = function(name) {
 nameParts = name.split("_");
 var result = [ ];
 var controlCollection = ASPx.GetControlCollection();
 for(var i = 1; i <= nameParts.length; i++) {
  var controlName = nameParts.slice(0, i).join("_");
  var control = controlCollection.Get(controlName);
  if(control)
   result.push(control);
 }
 return result;
}
ASPx.GetRootClientControl = function(childControlName) {
 var parentControls = ASPx.GetParentClientControls(childControlName);
 return parentControls[0];
}
ASPx.GetClientControlByElementID = function(elementID) {
 var parentControls = ASPx.GetParentClientControls(elementID);
 return parentControls[parentControls.length - 1];
}
ASPx.IsExists = function(obj){
 return (typeof(obj) != "undefined") && (obj != null);
}
ASPx.IsFunction = function(obj){
 return typeof(obj) == "function";
}
ASPx.IsNumber = function(str) {
 return !isNaN(parseFloat(str)) && isFinite(str);
}
ASPx.GetDefinedValue = function(value, defaultValue){
 return (typeof(value) != "undefined") ? value : defaultValue;
}
ASPx.CorrectJSFloatNumber = function(number) {
 var ret = 21; 
 var numString = number.toPrecision(21);
 numString = numString.replace("-", ""); 
 var integerDigitsCount = numString.indexOf(ASPx.PossibleNumberDecimalSeparators[0]);
 if(integerDigitsCount < 0)
  integerDigitsCount = numString.indexOf(ASPx.PossibleNumberDecimalSeparators[1]);
 var floatDigitsCount = numString.length - integerDigitsCount - 1;
 if(floatDigitsCount < 10)
  return number;
 if(integerDigitsCount > 0) {
  ret = integerDigitsCount + 12;
 }
 var toPrecisionNumber = Math.min(ret, 21);
 var newValueString = number.toPrecision(toPrecisionNumber);
 return parseFloat(newValueString, 10);
}
ASPx.CorrectRounding = function(number, step) { 
 var regex = /[,|.](.*)/,
  isFloatValue = regex.test(number),
  isFloatStep = regex.test(step);
 if(isFloatValue || isFloatStep) {
  var valueAccuracy = (isFloatValue) ? regex.exec(number)[0].length - 1 : 0,
   stepAccuracy = (isFloatStep) ? regex.exec(step)[0].length - 1 : 0,
   accuracy = Math.max(valueAccuracy, stepAccuracy);
  var multiplier = Math.pow(10, accuracy);
  number = Math.round((number + step) * multiplier) / multiplier;
  return number;
 }
 return number + step;
}
ASPx.GetActiveElement = function() {
 try{ return document.activeElement; } catch(e) { return null; }
}
var verticalScrollBarWidth;
ASPx.GetVerticalScrollBarWidth = function() {
 if(typeof(verticalScrollBarWidth) == "undefined") {
  var container = document.createElement("DIV");
  container.style.cssText = "position: absolute; top: 0px; left: 0px; visibility: hidden; width: 200px; height: 150px; overflow: hidden; box-sizing: content-box";
  document.body.appendChild(container);
  var child = document.createElement("P");
  container.appendChild(child);
  child.style.cssText = "width: 100%; height: 200px;";
  var widthWithoutScrollBar = child.offsetWidth;
  container.style.overflow = "scroll";
  var widthWithScrollBar = child.offsetWidth;
  if(widthWithoutScrollBar == widthWithScrollBar)
   widthWithScrollBar = container.clientWidth;
  verticalScrollBarWidth = widthWithoutScrollBar - widthWithScrollBar;
  document.body.removeChild(container);
 }
 return verticalScrollBarWidth;
}
function hideScrollBarCore(element, scrollName) {
 if(element.tagName == "IFRAME") {
  if((element.scrolling == "yes") || (element.scrolling == "auto")) {
   Attr.ChangeAttribute(element, "scrolling", "no");
   return true;
  }
 }
 else if(element.tagName == "DIV") {
  if((element.style[scrollName] == "scroll") || (element.style[scrollName] == "auto")) {
   Attr.ChangeStyleAttribute(element, scrollName, "hidden");
   return true;
  }
 }
 return false;
}
function restoreScrollBarCore(element, scrollName) {
 if(element.tagName == "IFRAME")
  return Attr.RestoreAttribute(element, "scrolling");
 else if(element.tagName == "DIV")
  return Attr.RestoreStyleAttribute(element, scrollName);
 return false;
}
ASPx.SetScrollBarVisibilityCore = function(element, scrollName, isVisible) {
 return isVisible ? restoreScrollBarCore(element, scrollName) : hideScrollBarCore(element, scrollName);
}
ASPx.SetScrollBarVisibility = function(element, isVisible) {
 if(ASPx.SetScrollBarVisibilityCore(element, "overflow", isVisible)) 
  return true;
 var result = ASPx.SetScrollBarVisibilityCore(element, "overflowX", isVisible)
  || ASPx.SetScrollBarVisibilityCore(element, "overflowY", isVisible);
 return result;
}
ASPx.SetInnerHtml = function(element, html) {
 if(Browser.IE) {
  element.innerHTML = "<em>&nbsp;</em>" + html;
  element.removeChild(element.firstChild);
 } else
  element.innerHTML = html;
}
ASPx.GetInnerText = function(container) {
 if(Browser.Safari && Browser.MajorVersion <= 5) {
  var filter = getHtml2PlainTextFilter();
  filter.innerHTML = container.innerHTML;
  ASPx.SetElementDisplay(filter, true);
  var innerText = filter.innerText;
  ASPx.SetElementDisplay(filter, false);
  return innerText;
 } else if(Browser.NetscapeFamily || Browser.WebKitFamily || (Browser.IE && Browser.Version >= 9) || Browser.Edge) {
  return container.textContent;
 } else
  return container.innerText;
}
var html2PlainTextFilter = null;
function getHtml2PlainTextFilter() {
 if(html2PlainTextFilter == null) {
  html2PlainTextFilter = document.createElement("DIV");
  html2PlainTextFilter.style.width = "0";
  html2PlainTextFilter.style.height = "0";
  html2PlainTextFilter.style.overflow = "visible";
  ASPx.SetElementDisplay(html2PlainTextFilter, false);
  document.body.appendChild(html2PlainTextFilter);
 }
 return html2PlainTextFilter;
}
ASPx.CreateHiddenField = function(name, id) {
 var input = document.createElement("INPUT");
 input.setAttribute("type", "hidden");
 if(name)
  input.setAttribute("name", name);
 if(id)
  input.setAttribute("id", id);
 return input;
}
ASPx.CloneObject = function(srcObject) {
  if(typeof(srcObject) != 'object' || srcObject == null)
 return srcObject;
  var newObject = { };
  for(var i in srcObject) 
 newObject[i] = srcObject[i];
  return newObject;
}
ASPx.IsPercentageSize = function(size) {
 return size && size.indexOf('%') != -1;
}
ASPx.GetElementById = function(id) {
 if(document.getElementById)
  return document.getElementById(id);
 else
  return document.all[id];
}
ASPx.GetInputElementById = function(id) {
 var elem = ASPx.GetElementById(id);
 if(!Browser.IE)
  return elem;
 if(elem) {
  if(elem.id == id)
   return elem;
  else {
   for(var i = 1; i < document.all[id].length; i++) {
    if(document.all[id][i].id == id)
     return document.all[id][i];
   }
  }
 }
 return null;
}
ASPx.GetElementByIdInDocument = function(documentObj, id) {
 if(documentObj.getElementById)
  return documentObj.getElementById(id);
 else
  return documentObj.all[id];
}
ASPx.GetIsParent = function(parentElement, element) {
 if(!parentElement || !element)
  return false;
 while(element){
  if(element === parentElement)
   return true;
  if(element.tagName === "BODY")
   return false;
  element = element.parentNode;
 }
 return false;
}
ASPx.GetParentById = function(element, id) {
 element = element.parentNode;
 while(element){
  if(element.id === id)
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetParentByPartialId = function(element, idPart){
 while(element && element.tagName != "BODY") {
  if(element.id && element.id.match(idPart)) 
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetParentByTagName = function(element, tagName) {
 tagName = tagName.toUpperCase();
 while(element) {
  if(element.tagName === "BODY")
   return null;
  if(element.tagName === tagName)
   return element;
  element = element.parentNode;
 }
 return null;
}
function getParentByClassNameInternal(element, className, selector) {
 while(element != null) {
  if(element.tagName == "BODY" || element.nodeName == "#document")
   return null;
  if(selector(element, className))
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetParentByPartialClassName = function(element, className) {
 return getParentByClassNameInternal(element, className, ASPx.ElementContainsCssClass);
}
ASPx.GetParentByClassName = function(element, className) {
 return getParentByClassNameInternal(element, className, ASPx.ElementHasCssClass);
}
ASPx.GetParentByTagNameAndAttributeValue = function(element, tagName, attrName, attrValue) {
 tagName = tagName.toUpperCase();
 while(element != null) {
  if(element.tagName == "BODY")
   return null;
  if(element.tagName == tagName && element[attrName] == attrValue)
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetParent = function(element, testFunc){
 if (!ASPx.IsExists(testFunc)) return null;
 while(element != null && element.tagName != "BODY"){
  if(testFunc(element))
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetElementTreeLine = function(element, stopTagName, stopFunc) {
 var result = [];
 stopTagName = stopTagName || "BODY";
 while(element != null) {
  if(!stopFunc && element.tagName == stopTagName)
   break;
  if(stopFunc && stopFunc(element))
   break;
  result.push(element);
  element = element.parentNode;
 }
 return result;
},
ASPx.IsScrollableElement = function(element, isHorzScrollable, isVertScrollable) {
 isHorzScrollable = ASPx.IsExists(isHorzScrollable) ? isHorzScrollable : true;
 isVertScrollable = ASPx.IsExists(isVertScrollable) ? isVertScrollable : true;
 var style = ASPx.GetCurrentStyle(element);
 var overflowStyleNames = [ "overflow" ];
 if(isHorzScrollable) 
  overflowStyleNames.push("overflowX");
 if(isVertScrollable)
  overflowStyleNames.push("overflowY");
 for(var i = 0; i < overflowStyleNames.length; i++)
  if(style[overflowStyleNames[i]] == "scroll" || style[overflowStyleNames[i]] == "auto")
   return true;
 return false;
},
ASPx.GetPreviousSibling = function(el) {
 if(el.previousElementSibling) {
  return el.previousElementSibling;
 } else {
  while(el = el.previousSibling) {
   if(el.nodeType === 1)
    return el;
  }
 }
}
ASPx.ElementHasCssClass = function(element, className) {
 try {
  var classList = element.classList;
  if(!classList) {
   if(!element.className)
    return false;
   var elementClasses = element.className.split(" ");
  }
  var classNames = className.split(" ");
  for(var i = classNames.length - 1; i >= 0; i--) {
   if(classList) {
    if(!classList.contains(classNames[i]))
     return false;
    continue;
   }
   if(Data.ArrayIndexOf(elementClasses, classNames[i]) < 0)
    return false;
  }
  return true;
 } catch(e) {
  return false;
 }
}
ASPx.ElementContainsCssClass = function(element, className) {
 try {
  if(!element.className)
   return false;
  return element.className.indexOf(className) != -1;
 } catch(e) {
  return false;
 }
}
ASPx.AddClassNameToElement = function (element, className) {
 if(!element || typeof(className) !== "string" ) return;
 className = className.trim();
 if(!ASPx.ElementHasCssClass(element, className) && className !== "")
  element.className = (element.className === "") ? className : element.className + " " + className;
}
ASPx.RemoveClassNameFromElement = function(element, className) {
 if(!element) return;
 var updClassName = " " + element.className + " ";
 var newClassName = updClassName.replace(" " + className + " ", " ");
 if(updClassName.length != newClassName.length)
  element.className = Str.Trim(newClassName);
}
ASPx.GetClassNameList = function(element) {
 if(element.classList)
  return [ ].slice.call(element.classList);
 return element.className.replace(/^\s+|\s+$/g, '').split(/\s+/);
}
function nodeListToArray(nodeList, filter) {
 var result = [];
 for(var i = 0, element; element = nodeList[i]; i++) {
  if(filter && !filter(element))
   continue;
  result.push(element);
 }
 return result;
}
function getItemByIndex(collection, index) {
 if(!index) index = 0;
 if(collection != null && collection.length > index)
  return collection[index];
 return null;
}
ASPx.GetChildNodesByClassName = function(parent, className) {
 if(parent.querySelectorAll) {
  var children = parent.querySelectorAll('.' + className);
  return nodeListToArray(children, function(element) { 
   return element.parentNode === parent;
  });
 }
 return ASPx.GetChildNodes(parent, function(elem) { return elem.className && ASPx.ElementHasCssClass(elem, className); });
}
ASPx.GetChildNodesByPartialClassName = function(element, className) {
 return ASPx.GetChildElementNodesByPredicate(element,
  function(child) {
   return ASPx.ElementContainsCssClass(child, className);
  });
}
ASPx.GetChildByPartialClassName = function(element, className, index) {
 if(element != null){    
  var collection = ASPx.GetChildNodesByPartialClassName(element, className);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetChildByClassName = function(element, className, index) {
 if(element != null){    
  var collection = ASPx.GetChildNodesByClassName(element, className);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetNodesByPartialClassName = function(element, className) {
 if(element.querySelectorAll) {
  var list = element.querySelectorAll('*[class*=' + className + ']');
  return nodeListToArray(list);
 }
 var collection = element.all || element.getElementsByTagName('*');
 var ret = [ ];
 if(collection != null) {
  for(var i = 0; i < collection.length; i ++) {
   if(ASPx.ElementContainsCssClass(collection[i], className))
    ret.push(collection[i]);
  }
 }
 return ret;
}
ASPx.GetNodesByClassName = function(parent, className) {
 if(parent.querySelectorAll) {
  var children = parent.querySelectorAll('.' + className);
  return nodeListToArray(children);
 }
 return ASPx.GetNodes(parent, function(elem) { return elem.className && ASPx.ElementHasCssClass(elem, className); });
}
ASPx.GetNodeByClassName = function(element, className, index) {
 if(element != null){    
  var collection = ASPx.GetNodesByClassName(element, className);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetChildById = function(element, id) {
 if(element.all) {
  var child = element.all[id];
  if(!child) {
   child = element.all(id); 
   if(!child)
    return Browser.IE ? document.getElementById(id) : null; 
  } 
  if(!ASPx.IsExists(child.length)) 
   return child;
  else
   return ASPx.GetElementById(id);
 }
 else
  return ASPx.GetElementById(id);
}
ASPx.GetNodesByPartialId = function(element, partialName, list) {
 if(element.id && element.id.indexOf(partialName) > -1) 
  list.push(element);
 if(element.childNodes) {
  for(var i = 0; i < element.childNodes.length; i ++) 
   ASPx.GetNodesByPartialId(element.childNodes[i], partialName, list);
 }
}
ASPx.GetNodesByTagName = function(element, tagName) {
 tagName = tagName.toUpperCase();
 if(element) {
  if(element.getElementsByTagName) 
   return element.getElementsByTagName(tagName);
  else if(element.all && element.all.tags !== undefined)
   return Browser.Netscape ? element.all.tags[tagName] : element.all.tags(tagName);
 }
 return null;
}
ASPx.GetNodeByTagName = function(element, tagName, index) {
 if(element != null){    
  var collection = ASPx.GetNodesByTagName(element, tagName);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetChildNodesByTagName = function(parent, tagName) {
 return ASPx.GetChildNodes(parent, function (child) { return child.tagName === tagName; });
}
ASPx.GetChildByTagName = function(element, tagName, index) {
 if(element != null){    
  var collection = ASPx.GetChildNodesByTagName(element, tagName);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.RetrieveByPredicate = function(scourceCollection, predicate) {
 var result = [];
 for(var i = 0; i < scourceCollection.length; i++) {
  var element = scourceCollection[i];
  if(!predicate || predicate(element)) 
   result.push(element);
 }
 return result;
}
ASPx.GetChildNodes = function(parent, predicate) {
 return ASPx.RetrieveByPredicate(parent.childNodes, predicate);
}
ASPx.GetNodes = function(parent, predicate) {
 var c = parent.all || parent.getElementsByTagName('*');
 return ASPx.RetrieveByPredicate(c, predicate);
}
ASPx.GetChildElementNodes = function(parent) {
 if(!parent) return null;
 return ASPx.GetChildNodes(parent, function(e) { return e.nodeType == 1 })
}
ASPx.GetChildElementNodesByPredicate = function(parent, predicate) {
 if(!parent) return null;
 if(!predicate) return ASPx.GetChildElementNodes(parent);
 return ASPx.GetChildNodes(parent, function(e) { return e.nodeType == 1 && predicate(e); })
}
ASPx.GetTextNode = function(element, index) {
 if(element != null){
  var collection = [ ];
  ASPx.GetTextNodes(element, collection);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetTextNodes = function(element, collection) {
 for(var i = 0; i < element.childNodes.length; i ++){
  var childNode = element.childNodes[i];
  if(ASPx.IsExists(childNode.nodeValue))
   collection.push(childNode);
  ASPx.GetTextNodes(childNode, collection);
 }
}
ASPx.GetNormalizedTextNode = function(element, index) {
 var textNode = ASPx.GetTextNode(element, index);
 if(textNode != null)
  ASPx.MergeAdjacentTextNodes(textNode);
 return textNode;
}
ASPx.MergeAdjacentTextNodes = function(firstTextNode) {
 if(!ASPx.IsExists(firstTextNode.nodeValue))
  return;
 var textNode = firstTextNode;
 while(textNode.nextSibling && ASPx.IsExists(textNode.nextSibling.nodeValue)) {
  textNode.nodeValue += textNode.nextSibling.nodeValue;
  textNode.parentNode.removeChild(textNode.nextSibling);
 }
}
ASPx.GetElementDocument = function(element) {
 return element.document || element.ownerDocument;
}
ASPx.RemoveElement = function(element) {
 if(element && element.parentNode)
  element.parentNode.removeChild(element);
}
ASPx.ReplaceTagName = function(element, newTagName, cloneChilds) {
 if(element.nodeType != 1)
  return null;
 if(element.nodeName == newTagName)
  return element;
 cloneChilds = cloneChilds !== undefined ? cloneChilds : true;
 var doc = element.ownerDocument;
 var newElem = doc.createElement(newTagName);
 Attr.CopyAllAttributes(element, newElem);
 if(cloneChilds) {
  for(var i = 0; i < element.childNodes.length; i++)
   newElem.appendChild(element.childNodes[i].cloneNode(true));
 }
 else {
  for(var child; child = element.firstChild; )
   newElem.appendChild(child);
 }
 element.parentNode.replaceChild(newElem, element);
 return newElem;
}
ASPx.RemoveOuterTags = function(element) {
 if(ASPx.Browser.IE) {
  element.insertAdjacentHTML( 'beforeBegin', element.innerHTML ) ;
  ASPx.RemoveElement(element);
 } else {
  var docFragment = element.ownerDocument.createDocumentFragment();
  for(var i = 0; i < element.childNodes.length; i++)
   docFragment.appendChild(element.childNodes[i].cloneNode(true));
  element.parentNode.replaceChild(docFragment, element);
 }
}
ASPx.WrapElementInNewElement = function(element, newElementTagName) { 
 var wrapElement = null;
 if(Browser.IE) {
  var wrapElement = element.ownerDocument.createElement(newElementTagName);
  wrapElement.appendChild(element.cloneNode(true));
  element.parentNode.insertBefore(wrapElement, element);
  element.parentNode.removeChild(element);
 } else {
  var docFragment = element.ownerDocument.createDocumentFragment();
  wrapElement = element.ownerDocument.createElement(newElementTagName);
  docFragment.appendChild(wrapElement);
  wrapElement.appendChild(element.cloneNode(true));
  element.parentNode.replaceChild(docFragment, element);
 }
 return wrapElement;
}
ASPx.InsertElementAfter = function(newElement, targetElement) {
 var parentElem = targetElement.parentNode;
 if(parentElem.childNodes[parentElem.childNodes.length - 1] == targetElement)
  parentElem.appendChild(newElement);
 else
  parentElem.insertBefore(newElement, targetElement.nextSibling);
}
ASPx.SetElementOpacity = function(element, value) {
  var useOpacityStyle = !Browser.IE || Browser.Version > 8;
  if(useOpacityStyle){
   element.style.opacity = value;
  } else {
   if(typeof(element.filters) === "object" && element.filters["DXImageTransform.Microsoft.Alpha"])
    element.filters.item("DXImageTransform.Microsoft.Alpha").Opacity = value*100;
   else
   element.style.filter = "alpha(opacity=" + (value * 100) + ")";
  }
}
ASPx.GetElementOpacity = function(element) {
 var useOpacityStyle = !Browser.IE || Browser.Version > 8;
 if(useOpacityStyle)
  return parseFloat(ASPx.GetCurrentStyle(element).opacity);
 else {
  if(typeof(element.filters) === "object" && element.filters["DXImageTransform.Microsoft.Alpha"]){
   return element.filters.item("DXImageTransform.Microsoft.Alpha").Opacity / 100;
  } else {
   var alphaValue = ASPx.GetCurrentStyle(element).filter;
   var value = alphaValue.replace("alpha(opacity=", "");
   value = value.replace(")", "");
   return parseInt(value) / 100;
  }
  return 100;
 }
}
ASPx.GetElementDisplay = function(element, isCurrentStyle) {
 if (isCurrentStyle)
  return ASPx.GetCurrentStyle(element).display != "none";
 return element.style.display != "none";
}
ASPx.SetElementDisplay = function(element, value, checkCurrentStyle, makeInline) {
 if(!element) return;
 if(typeof(value) === "string")
  element.style.display = value;
 else if(!value)
  element.style.display = "none";
 else {
  element.style.display = "";
  if(checkCurrentStyle && ASPx.GetCurrentStyle(element).display === "none"){
   var displayAddon = makeInline ? "inline-" : "";
   switch(element.tagName){
    case "TABLE": {
     element.style.display = displayAddon + "table";
     break;
    }
    default: {
     element.style.display = displayAddon + "block";
     break;
    }
   }
  }
 }
}
ASPx.GetElementVisibility = function(element, isCurrentStyle) {
 if(isCurrentStyle)
  return ASPx.GetCurrentStyle(element).visibility != "hidden";
 return element.style.visibility != "hidden";
}
ASPx.SetElementVisibility = function(element, value) {
 if(!element) return;
 if(typeof(value) === "string")
  element.style.visibility = value;
 else
  element.style.visibility = value ? "visible" : "hidden";
}
ASPx.IsElementVisible = function(element, isCurrentStyle) {
 while(element && element.tagName != "BODY") {
  if(!ASPx.GetElementDisplay(element, isCurrentStyle) || (!ASPx.GetElementVisibility(element, isCurrentStyle) && !Attr.IsExistsAttribute(element, "errorFrame")))
     return false;
  element = element.parentNode;
 }
 return true;
}
ASPx.IsElementDisplayed = function(element) {
 while(element && element.tagName != "BODY") {
  if(!ASPx.GetElementDisplay(element))
     return false;
  element = element.parentNode;
 }
 return true;
}
ASPx.AddStyleSheetLinkToDocument = function(doc, linkUrl) {
 var newLink = createStyleLink(doc, linkUrl);
 var head = ASPx.GetHeadElementOrCreateIfNotExist(doc);
 head.appendChild(newLink);
}
ASPx.GetHeadElementOrCreateIfNotExist = function(doc) {
 var elements = ASPx.GetNodesByTagName(doc, "head");
 var head = null;
 if(elements.length == 0) {
  head = doc.createElement("head");
  head.visibility = "hidden";
  doc.insertBefore(head, doc.body);
 } else
  head = elements[0];
 return head;
}
function createStyleLink(doc, url) {
 var newLink = doc.createElement("link");
 Attr.SetAttribute(newLink, "href", url);
 Attr.SetAttribute(newLink, "type", "text/css");
 Attr.SetAttribute(newLink, "rel", "stylesheet");
 return newLink;
}
ASPx.GetCurrentStyle = function(element) {
 if(element.currentStyle)
  return element.currentStyle;
 else if(document.defaultView && document.defaultView.getComputedStyle) { 
  var result = document.defaultView.getComputedStyle(element, null);
  if(!result && Browser.Firefox && window.frameElement) {
   var changes = [];
   var curElement = window.frameElement;
   while(!(result = document.defaultView.getComputedStyle(element, null))) {
    changes.push([curElement, curElement.style.display]);
    ASPx.SetStylesCore(curElement, "display", "block", true);
    curElement = curElement.tagName == "BODY" ? curElement.ownerDocument.defaultView.frameElement : curElement.parentNode;
   }
   result = ASPx.CloneObject(result);
   for(var ch, i = 0; ch = changes[i]; i++)
    ASPx.SetStylesCore(ch[0], "display", ch[1]);
   var reflow = document.body.offsetWidth; 
  }
  return result;
 }
 return window.getComputedStyle(element, null);
}
ASPx.CreateStyleSheetInDocument = function(doc) {
 if(doc.createStyleSheet) {
  try {
   return doc.createStyleSheet();
  }
  catch(e) {
   var message = "The CSS link limit (31) has been exceeded. Please enable CSS merging or reduce the number of CSS files on the page. For details, see http://www.devexpress.com/Support/Center/p/K18487.aspx.";
   throw new Error(message);
  }
 }
 else {
  var styleSheet = doc.createElement("STYLE");
  ASPx.GetNodeByTagName(doc, "HEAD", 0).appendChild(styleSheet);
  return styleSheet.sheet;
 }
}
ASPx.currentStyleSheet = null;
ASPx.GetCurrentStyleSheet = function() {
 if(!ASPx.currentStyleSheet)
  ASPx.currentStyleSheet = ASPx.CreateStyleSheetInDocument(document);
 return ASPx.currentStyleSheet;
}
function getStyleSheetRules(styleSheet){
 try {
  return Browser.IE && Browser.Version == 8 ? styleSheet.rules : styleSheet.cssRules;
 }
 catch(e) {
  return null;
 }
}
ASPx.cachedCssRules = { };
ASPx.GetStyleSheetRules = function (className, stylesStorageDocument) {
 if(ASPx.cachedCssRules[className]) {
  if(ASPx.cachedCssRules[className] != ASPx.EmptyObject)
   return ASPx.cachedCssRules[className];
  return null;
 }
 var result = iterateStyleSheetRules(stylesStorageDocument, function(rule) {
  if(rule.selectorText == "." + className){
   ASPx.cachedCssRules[className] = rule;
   return rule;
  }
 });
 if(ASPx.IsExists(result))
  return result;
 ASPx.cachedCssRules[className] = ASPx.EmptyObject;
 return null;
}
function iterateStyleSheetRules(stylesStorageDocument, callback) {
 var doc = stylesStorageDocument || document;
 for(var i = 0; i < doc.styleSheets.length; i ++){
  var styleSheet = doc.styleSheets[i];
  var rules = getStyleSheetRules(styleSheet);
  if(rules != null){
   for(var j = 0; j < rules.length; j ++) {
    var result = callback(rules[j]);
    if(result !== undefined)
     return result;
   }
  }
 }
};
ASPx.ClearCachedCssRules = function(){
 ASPx.cachedCssRules = { };
}
var styleCount = 0;
var styleNameCache = { };
ASPx.CreateImportantStyleRule = function(styleSheet, cssText, postfix, prefix) {
 styleSheet = styleSheet || ASPx.GetCurrentStyleSheet();
 var cacheKey = (postfix ? postfix + "||" : "") + cssText + (prefix ? "||" + prefix : "");
 if(styleNameCache[cacheKey])
  return styleNameCache[cacheKey];
 prefix = prefix ? prefix + " " : "";
 var className = "dxh" + styleCount + (postfix ? postfix : "");
 ASPx.AddStyleSheetRule(styleSheet, prefix + "." + className, ASPx.CreateImportantCssText(cssText));
 styleCount++;
 styleNameCache[cacheKey] = className;
 return className; 
}
ASPx.CreateImportantCssText = function(cssText) {
 var newText = "";
 var attributes = cssText.split(";");
 for(var i = 0; i < attributes.length; i++){
  if(attributes[i] != "")
   newText += attributes[i] + " !important;";
 }
 return newText;
}
ASPx.AddStyleSheetRule = function(styleSheet, selector, cssText){
 if(!cssText) return;
 if(Browser.IE)
  styleSheet.addRule(selector, cssText);
 else
  styleSheet.insertRule(selector + " { " + cssText + " }", styleSheet.cssRules.length);
}
ASPx.GetPointerCursor = function() {
 return "pointer";
}
ASPx.SetPointerCursor = function(element) {
 if(element.style.cursor == "")
  element.style.cursor = ASPx.GetPointerCursor();
}
ASPx.SetElementFloat = function(element, value) {
 if(ASPx.IsExists(element.style.cssFloat))
  element.style.cssFloat = value;
 else if(ASPx.IsExists(element.style.styleFloat))
  element.style.styleFloat = value;
 else
  Attr.SetAttribute(element.style, "float", value);
}
ASPx.GetElementFloat = function(element) {
 var currentStyle = ASPx.GetCurrentStyle(element);
 if(ASPx.IsExists(currentStyle.cssFloat))
  return currentStyle.cssFloat;
 if(ASPx.IsExists(currentStyle.styleFloat))
  return currentStyle.styleFloat;
 return Attr.GetAttribute(currentStyle, "float");
}
function getElementDirection(element) {
 return ASPx.GetCurrentStyle(element).direction;
}
ASPx.IsElementRightToLeft = function(element) {
 return getElementDirection(element) == "rtl";
}
ASPx.AdjustVerticalMarginsInContainer = function(container) {
 var containerBorderAndPaddings = ASPx.GetTopBottomBordersAndPaddingsSummaryValue(container);
 var flowElements = [], floatElements = [], floatTextElements = [];
 var maxHeight = 0, maxFlowHeight = 0;
 for(var i = 0; i < container.childNodes.length; i++) {
  var element = container.childNodes[i];
  if(!element.offsetHeight) continue;
  ASPx.ClearVerticalMargins(element);
 }
 for(var i = 0; i < container.childNodes.length; i++) {
  var element = container.childNodes[i];
  if(!element.offsetHeight) continue;
  var float = ASPx.GetElementFloat(element);
  var isFloat = (float === "left" || float === "right");
  if(isFloat)
   floatElements.push(element)
  else {
   flowElements.push(element);
   if(element.tagName !== "IMG"){
    if(!ASPx.IsTextWrapped(element))
     element.style.verticalAlign = 'baseline'; 
    floatTextElements.push(element);
   }
   if(element.tagName === "DIV")
    Attr.ChangeStyleAttribute(element, "float", "left"); 
  }
  if(element.offsetHeight > maxHeight) 
   maxHeight = element.offsetHeight;
  if(!isFloat && element.offsetHeight > maxFlowHeight) 
   maxFlowHeight = element.offsetHeight;
 }
 for(var i = 0; i < flowElements.length; i++) 
  Attr.RestoreStyleAttribute(flowElements[i], "float");
 var containerBorderAndPaddings = ASPx.GetTopBottomBordersAndPaddingsSummaryValue(container);
 var containerHeight = container.offsetHeight - containerBorderAndPaddings;
 if(maxHeight == containerHeight) {
  var verticalAlign = ASPx.GetCurrentStyle(container).verticalAlign;
  for(var i = 0; i < floatTextElements.length; i++)
   floatTextElements[i].style.verticalAlign = '';
  containerHeight = container.offsetHeight - containerBorderAndPaddings;
  for(var i = 0; i < floatElements.length; i++)
   adjustVerticalMarginsCore(floatElements[i], containerHeight, verticalAlign, true);
  for(var i = 0; i < flowElements.length; i++) {
   if(maxFlowHeight != maxHeight)
    adjustVerticalMarginsCore(flowElements[i], containerHeight, verticalAlign);
  }
 }
}
ASPx.AdjustVerticalMargins = function(element) {
 ASPx.ClearVerticalMargins(element);
 var parentElement = element.parentNode;
 var parentHeight = parentElement.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(parentElement);
 adjustVerticalMarginsCore(element, parentHeight, ASPx.GetCurrentStyle(parentElement).verticalAlign);
}
function adjustVerticalMarginsCore(element, parentHeight, verticalAlign, toBottom) {
 var marginTop;
 if(verticalAlign == "top")
  marginTop = 0;
 else if(verticalAlign == "bottom")
  marginTop = parentHeight - element.offsetHeight;
 else
  marginTop = (parentHeight - element.offsetHeight) / 2;
 if(marginTop !== 0){
  var marginAttr = (toBottom ? Math.ceil(marginTop) : Math.floor(marginTop)) + "px"
  element.style.marginTop = marginAttr;
 }
}
ASPx.ClearVerticalMargins = function(element) {
 element.style.marginTop = "";
 element.style.marginBottom = "";
}
ASPx.AdjustHeightInContainer = function(container) {
 var height = container.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(container);
 for(var i = 0; i < container.childNodes.length; i++) {
  var element = container.childNodes[i];
  if(!element.offsetHeight) continue;
  ASPx.ClearHeight(element);
 }
 var elements = [];
 var childrenHeight = 0;
 for(var i = 0; i < container.childNodes.length; i++) {
  var element = container.childNodes[i];
  if(!element.offsetHeight) continue;
  childrenHeight += element.offsetHeight + ASPx.GetTopBottomMargins(element);
  elements.push(element);
 }
 if(elements.length > 0 && childrenHeight < height) {
  var correctedHeight = 0;
  for(var i = 0; i < elements.length; i++) {
   var elementHeight = 0;
   if(i < elements.length - 1){
    var elementHeight = Math.floor(height / elements.length);
    correctedHeight += elementHeight;
   }
   else{
    var elementHeight = height - correctedHeight;
    if(elementHeight < 0) elementHeight = 0;
   }
   adjustHeightCore(elements[i], elementHeight);
  }
 }
}
ASPx.AdjustHeight = function(element) {
 ASPx.ClearHeight(element);
 var parentElement = element.parentNode;
 var height = parentElement.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(parentElement);
 adjustHeightCore(element, height);
}
function adjustHeightCore(element, height) {
 var height = height - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(element);
 if(height < 0) height = 0;
 element.style.height = height + "px";
}
ASPx.ClearHeight = function(element) {
 element.style.height = "";
}
ASPx.ShrinkWrappedTextInContainer = function(container) {
 if(!container) return;
 for(var i = 0; i < container.childNodes.length; i++){
  var child = container.childNodes[i];
  if(child.style && ASPx.IsTextWrapped(child)) {
   Attr.ChangeStyleAttribute(child, "width", "1px");
   child.shrinkedTextContainer = true;
  }
 }
}
ASPx.AdjustWrappedTextInContainer = function(container) {
 if(!container) return;
 var textContainer, leftWidth = 0, rightWidth = 0;
 for(var i = 0; i < container.childNodes.length; i++){
  var child = container.childNodes[i];
  if(child.tagName === "BR")
   return;
  if(!child.tagName)
   continue;
  if(child.tagName !== "IMG"){
   textContainer = child;
   if(ASPx.IsTextWrapped(textContainer)){
    if(!textContainer.shrinkedTextContainer)
     textContainer.style.width = "";
    textContainer.style.marginRight = "";
   }
  }
  else {
   if(child.offsetWidth === 0){
    Evt.AttachEventToElement(child, "load", function (evt) {
     ASPx.AdjustWrappedTextInContainer(container);
    });
    return;
   }
   var width = child.offsetWidth + ASPx.GetLeftRightMargins(child);
   if(textContainer)
    rightWidth += width;
   else
    leftWidth += width;
  }
 }
 if(textContainer && ASPx.IsTextWrapped(textContainer)) {
  var containerWidth = container.offsetWidth - ASPx.GetLeftRightBordersAndPaddingsSummaryValue(container);
  if(textContainer.shrinkedTextContainer) {
   Attr.RestoreStyleAttribute(textContainer, "width");
   Attr.ChangeStyleAttribute(container, "width", containerWidth + "px");
  }
  if(textContainer.offsetWidth + leftWidth + rightWidth >= containerWidth) {
    if(rightWidth > 0 && !textContainer.shrinkedTextContainer)
    textContainer.style.width = (containerWidth - rightWidth) + "px";
   else if(leftWidth > 0){
    if(ASPx.IsElementRightToLeft(container))
     textContainer.style.marginLeft = leftWidth + "px";
    else
     textContainer.style.marginRight = leftWidth + "px";
   }
  }
 }
}
ASPx.IsTextWrapped = function(element) {
 return element && ASPx.GetCurrentStyle(element).whiteSpace !== "nowrap";
}
ASPx.IsValidPosition = function(pos){
 return pos != ASPx.InvalidPosition && pos != -ASPx.InvalidPosition;
}
ASPx.getSpriteMainElement = function(element) {
 var cssClassMarker = "dx-acc";
 if(ASPx.ElementContainsCssClass(element, cssClassMarker))
  return element;
 if(element.parentNode && ASPx.ElementContainsCssClass(element.parentNode, cssClassMarker))
  return element.parentNode;
 return element;
}
ASPx.GetAbsoluteX = function(curEl){
 return ASPx.GetAbsolutePositionX(curEl);
}
ASPx.GetAbsoluteY = function(curEl){
 return ASPx.GetAbsolutePositionY(curEl);
}
ASPx.SetAbsoluteX = function(element, x){
 element.style.left = ASPx.PrepareClientPosForElement(x, element, true) + "px";
}
ASPx.SetAbsoluteY = function(element, y){
 element.style.top = ASPx.PrepareClientPosForElement(y, element, false) + "px";
}
ASPx.GetAbsolutePositionX = function(element){
 if(Browser.IE)
  return getAbsolutePositionX_IE(element);
 else if(Browser.Firefox && Browser.Version >= 3)
  return getAbsolutePositionX_FF3(element);
 else if(Browser.Opera)
  return getAbsolutePositionX_Opera(element);
 else if(Browser.NetscapeFamily && (!Browser.Firefox || Browser.Version < 3))
  return getAbsolutePositionX_NS(element);
 else if(Browser.WebKitFamily && Browser.WebKitTouchUI)
  return getAbsolutePositionX_Opera(element);
 else if(Browser.WebKitFamily || Browser.Edge)
  return getAbsolutePositionX_FF3(element);
 else
  return getAbsolutePositionX_Other(element);
}
function getAbsolutePositionX_Opera(curEl){
 var isFirstCycle = true;
 var pos = getAbsoluteScrollOffset_OperaFF(curEl, true);
 while(curEl != null) {
  pos += curEl.offsetLeft;
  if(!isFirstCycle)
   pos -= curEl.scrollLeft;
  curEl = curEl.offsetParent;
  isFirstCycle = false;
 }
 pos += document.body.scrollLeft;
 return pos;
}
function getAbsolutePositionX_IE(element){
 if(element == null || Browser.IE && element.parentNode == null) return 0; 
 return element.getBoundingClientRect().left + ASPx.GetDocumentScrollLeft();
}
function getAbsolutePositionX_FF3(element){
 if(element == null) return 0;
 var x = element.getBoundingClientRect().left + ASPx.GetDocumentScrollLeft();
 return Math.round(x);
}
function getAbsolutePositionX_NS(curEl){
 var pos = getAbsoluteScrollOffset_OperaFF(curEl, true);
 var isFirstCycle = true;
 while(curEl != null) {
  pos += curEl.offsetLeft;
  if(!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollLeft;
  if(!isFirstCycle && Browser.Firefox){
   var style = ASPx.GetCurrentStyle(curEl);
   if(curEl.tagName == "DIV" && style.overflow != "visible")
    pos += ASPx.PxToInt(style.borderLeftWidth);
  }
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
function getAbsolutePositionX_Safari(curEl){
 var pos = getAbsoluteScrollOffset_WebKit(curEl, true);
 var isSafariVerNonLessThan3OrChrome = Browser.Safari && Browser.Version >= 3 || Browser.Chrome;
 if(curEl != null){
  var isFirstCycle = true;
  if(isSafariVerNonLessThan3OrChrome && curEl.tagName == "TD") {
   pos += curEl.offsetLeft;
   curEl = curEl.offsetParent;
   isFirstCycle = false;
  }
  var hasNonStaticElement = false;
  while (curEl != null) {
   pos += curEl.offsetLeft;
   var style = ASPx.GetCurrentStyle(curEl);
   var isNonStatic = style.position !== "" && style.position !== "static";
   if(isNonStatic)
    hasNonStaticElement = true;
   var safariDisplayTable = Browser.Safari && Browser.Version >= 8 && style.display === "table";
   var posDiv = curEl.tagName == "DIV" && isNonStatic && !safariDisplayTable;
   if(!isFirstCycle && (curEl.tagName == "TD" || curEl.tagName == "TABLE" || posDiv))
    pos += curEl.clientLeft;
   isFirstCycle = false;
   curEl = curEl.offsetParent;
  }
  if(!hasNonStaticElement && (document.documentElement.style.position === "" || document.documentElement.style.position === "static"))
   pos += document.documentElement.offsetLeft;
 }
 return pos;
}
function getAbsolutePositionX_Other(curEl){
 var pos = 0;
 var isFirstCycle = true;
 while(curEl != null) {
  pos += curEl.offsetLeft;
  if(!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollLeft;
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
ASPx.GetAbsolutePositionY = function(element){
 if(Browser.IE)
  return getAbsolutePositionY_IE(element);
 else if(Browser.Firefox && Browser.Version >= 3)
  return getAbsolutePositionY_FF3(element);
 else if(Browser.Opera)
  return getAbsolutePositionY_Opera(element);
 else if(Browser.NetscapeFamily && (!Browser.Firefox || Browser.Version < 3))
  return getAbsolutePositionY_NS(element);
 else if(Browser.WebKitFamily && Browser.WebKitTouchUI)
  return getAbsolutePositionY_Opera(element);
 else if(Browser.WebKitFamily || Browser.Edge)
  return getAbsolutePositionY_FF3(element);
 else
  return getAbsolutePositionY_Other(element);
}
function getAbsolutePositionY_Opera(curEl){
 var isFirstCycle = true;
 if(curEl && curEl.tagName == "TR" && curEl.cells.length > 0)
  curEl = curEl.cells[0];
 var pos = getAbsoluteScrollOffset_OperaFF(curEl, false);
 while(curEl != null) {
  pos += curEl.offsetTop;
  if(!isFirstCycle)
   pos -= curEl.scrollTop;
  curEl = curEl.offsetParent;
  isFirstCycle = false;
 }
 pos += document.body.scrollTop;
 return pos;
}
function getAbsolutePositionY_IE(element){
 if(element == null || Browser.IE && element.parentNode == null) return 0; 
 return element.getBoundingClientRect().top + ASPx.GetDocumentScrollTop();
}
function getAbsolutePositionY_FF3(element){
 if(element == null) return 0;
 var y = element.getBoundingClientRect().top + ASPx.GetDocumentScrollTop();
 return Math.round(y);
}
function getAbsolutePositionY_NS(curEl){
 var pos = getAbsoluteScrollOffset_OperaFF(curEl, false);
 var isFirstCycle = true;
 while(curEl != null) {
  pos += curEl.offsetTop;
  if(!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollTop;
  if(!isFirstCycle && Browser.Firefox){
   var style = ASPx.GetCurrentStyle(curEl);
   if(curEl.tagName == "DIV" && style.overflow != "visible")
    pos += ASPx.PxToInt(style.borderTopWidth);
  }
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
var WebKit3TDRealInfo = {
 GetOffsetTop: function(tdElement){
  switch(ASPx.GetCurrentStyle(tdElement).verticalAlign){
   case "middle":
    return Math.round(tdElement.offsetTop - (tdElement.offsetHeight - tdElement.clientHeight )/2 + tdElement.clientTop);
   case "bottom":
    return tdElement.offsetTop - tdElement.offsetHeight + tdElement.clientHeight + tdElement.clientTop;
  }
  return tdElement.offsetTop;
 },
 GetClientHeight: function(tdElement){
  var valign = ASPx.GetCurrentStyle(tdElement).verticalAlign;
  switch(valign){
   case "middle":
    return tdElement.clientHeight + tdElement.offsetTop * 2;
   case "top":
    return tdElement.offsetHeight - tdElement.clientTop * 2;
   case "bottom":
    return tdElement.clientHeight + tdElement.offsetTop;
  }
  return tdElement.clientHeight;
 }
}
function getAbsolutePositionY_Safari(curEl){
 var pos = getAbsoluteScrollOffset_WebKit(curEl, false);
 var isSafariVerNonLessThan3OrChrome = Browser.Safari && Browser.Version >= 3 || Browser.Chrome;
 if(curEl != null){
  var isFirstCycle = true;
  if(isSafariVerNonLessThan3OrChrome && curEl.tagName == "TD") {
   pos += WebKit3TDRealInfo.GetOffsetTop(curEl);
   curEl = curEl.offsetParent;
   isFirstCycle = false;
  }
  var hasNonStaticElement = false;
  while (curEl != null) {
   pos += curEl.offsetTop;
   var style = ASPx.GetCurrentStyle(curEl);
   var isNonStatic = style.position !== "" && style.position !== "static";
   if(isNonStatic)
    hasNonStaticElement = true;
   var safariDisplayTable = Browser.Safari && Browser.Version >= 8 && style.display === "table";
   var posDiv = curEl.tagName == "DIV" && isNonStatic && !safariDisplayTable;
   if(!isFirstCycle && (curEl.tagName == "TD" || curEl.tagName == "TABLE" || posDiv))
    pos += curEl.clientTop;
   isFirstCycle = false;
   curEl = curEl.offsetParent;
  }
  if(!hasNonStaticElement && (document.documentElement.style.position === "" || document.documentElement.style.position === "static"))
   pos += document.documentElement.offsetTop;
 }
 return pos;
}
function getAbsoluteScrollOffset_OperaFF(curEl, isX) {
 var pos = 0;   
 var isFirstCycle = true;
 while(curEl != null) {
  if(curEl.tagName == "BODY")
   break;
  var style = ASPx.GetCurrentStyle(curEl);
  if(style.position == "absolute")
   break;
  if(!isFirstCycle && curEl.tagName == "DIV" && (style.position == "" || style.position == "static"))
   pos -= isX ? curEl.scrollLeft : curEl.scrollTop;
  curEl = curEl.parentNode;
  isFirstCycle = false;
 }
 return pos; 
}
function getAbsoluteScrollOffset_WebKit(curEl, isX) {
 var pos = 0;   
 var isFirstCycle = true;
 var step = 0;
 var absoluteWasFoundAtStep = -1;
 var isThereFixedParent = false;
 while(curEl != null) {
  if(curEl.tagName == "BODY")
   break;
  var style = ASPx.GetCurrentStyle(curEl);
  var positionIsDefault = style.position == "" || style.position == "static";
  var absoluteWasFoundAtPreviousStep = absoluteWasFoundAtStep >= 0 && absoluteWasFoundAtStep < step;
  var canHaveScrolls = curEl.tagName == "DIV" || curEl.tagName == "SECTION" || curEl.tagName == "FORM";
  if(!isFirstCycle && canHaveScrolls && (!positionIsDefault || !absoluteWasFoundAtPreviousStep))
   pos -= isX ? curEl.scrollLeft : curEl.scrollTop;
  if(style.position == "absolute")
   absoluteWasFoundAtStep = step;
  else if(style.position == "relative")
   absoluteWasFoundAtStep = -1;
  else if(style.position == "fixed")
   isThereFixedParent = true;
  curEl = curEl.parentNode;
  isFirstCycle = false;
  step ++;
 }
 if(isThereFixedParent)
  pos += isX ? ASPx.GetDocumentScrollLeft() : ASPx.GetDocumentScrollTop();
 return pos; 
}
function getAbsolutePositionY_Other(curEl){
 var pos = 0;
 var isFirstCycle = true;
 while(curEl != null) {
  pos += curEl.offsetTop;
  if(!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollTop;
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
function createElementMock(element) {
 var div = document.createElement('DIV');
 div.style.top = "0px";
 div.style.left = "0px";
 div.visibility = "hidden";
 div.style.position = ASPx.GetCurrentStyle(element).position;
 return div;
}
ASPx.PrepareClientPosElementForOtherParent = function(pos, element, otherParent, isX) {
 if(element.parentNode == otherParent)
  return ASPx.PrepareClientPosForElement(pos, element, isX);
 var elementMock = createElementMock(element);
 otherParent.appendChild(elementMock); 
 var preparedPos = ASPx.PrepareClientPosForElement(pos, elementMock, isX);
 otherParent.removeChild(elementMock);
 return preparedPos;
}
ASPx.PrepareClientPosForElement = function(pos, element, isX) {
 pos -= ASPx.GetPositionElementOffset(element, isX);
 return pos;
}
function getExperimentalPositionOffset(element, isX) {
 var div = createElementMock(element);
 if(div.style.position == "static")
  div.style.position = "absolute";
 element.parentNode.appendChild(div); 
 var realPos = isX ? ASPx.GetAbsoluteX(div) : ASPx.GetAbsoluteY(div);
 element.parentNode.removeChild(div);
 return Math.round(realPos);
}
ASPx.GetPositionElementOffset = function(element, isX) {
 return getExperimentalPositionOffset(element, isX);
}
function getPositionElementOffsetCore(element, isX) {
 var curEl = element.offsetParent;
 var offset = 0;
 var scroll = 0;
 var isThereFixedParent = false;
 var isFixed = false;
 var hasDisplayTableParent = false;
 var position = "";
 while(curEl != null) {
  var tagName = curEl.tagName;
  if(tagName == "HTML"){
   break;
  }
  if(tagName == "BODY"){
   if(!Browser.Opera && !Browser.Chrome && !Browser.Edge){
    var style = ASPx.GetCurrentStyle(curEl);
    if(style.position != "" && style.position != "static"){
     offset += ASPx.PxToInt(isX ? style.left : style.top);
     offset += ASPx.PxToInt(isX ? style.marginLeft : style.marginTop);
    }
   }
   break;
  }
  var style = ASPx.GetCurrentStyle(curEl);
  isFixed = style.position == "fixed";
  if(isFixed) {
   isThereFixedParent = true;
   if(Browser.IE) 
    return getExperimentalPositionOffset(element, isX); 
  }
  hasDisplayTableParent = style.display == "table" && (style.position == "absolute" || style.position == "relative");
  if(hasDisplayTableParent && Browser.IE)
   return getExperimentalPositionOffset(element, isX);
  if(style.position == "absolute" || isFixed || style.position == "relative") {
   offset += isX ? curEl.offsetLeft : curEl.offsetTop;
   offset += ASPx.PxToInt(isX ? style.borderLeftWidth : style.borderTopWidth);
  }
  if(style.position == "relative") 
   scroll += getElementChainScroll(curEl, curEl.offsetParent, isX);
  scroll += isX ? curEl.scrollLeft : curEl.scrollTop;
  curEl = curEl.offsetParent;
 }
 offset -= scroll; 
 if((Browser.IE || Browser.Firefox && Browser.Version >= 3 || Browser.WebKitFamily || Browser.Edge) && isThereFixedParent)
  offset += isX ? ASPx.GetDocumentScrollLeft() : ASPx.GetDocumentScrollTop();
 return offset;
}
function getElementChainScroll(startElement, endElement, isX){
 var curEl = startElement.parentNode;
 var scroll = 0;
 while(curEl != endElement){
  scroll += isX ? curEl.scrollLeft : curEl.scrollTop;
  curEl = curEl.parentNode;
 }
 return scroll;
}
ASPx.GetSizeOfText = function(text, textCss) {
 var testContainer = document.createElement("tester");
 var defaultLineHeight = ASPx.Browser.Firefox ? "1" : "";
 testContainer.style.fontSize = textCss.fontSize;
 testContainer.style.fontFamily = textCss.fontFamily;
 testContainer.style.fontWeight = textCss.fontWeight;
 testContainer.style.letterSpacing = textCss.letterSpacing;
 testContainer.style.lineHeight = textCss.lineHeight || defaultLineHeight;
 testContainer.style.position = "absolute";
 testContainer.style.top = ASPx.InvalidPosition + "px";
 testContainer.style.left = ASPx.InvalidPosition + "px";
 testContainer.style.width = "auto";
 testContainer.style.whiteSpace = "nowrap";
 testContainer.appendChild(document.createTextNode(text));
 var testElement = document.body.appendChild(testContainer);
 var size = {
  "width": testElement.offsetWidth,
  "height": testElement.offsetHeight
 };
 document.body.removeChild(testElement);
 return size;
}
ASPx.PointToPixel = function(points, addPx) {  
 var result = 0;
 try {
  var indexOfPt = points.toLowerCase().indexOf("pt");
  if(indexOfPt > -1)
   result = parseInt(points.substr(0, indexOfPt)) * 96 / 72;
  else
   result = parseInt(points) * 96 / 72;
  if(addPx)
   result = result + "px";
 } catch(e) {}
 return result;
}
ASPx.PixelToPoint = function(pixels, addPt) { 
 var result = 0;
 try {
  var indexOfPx = pixels.toLowerCase().indexOf("px");
  if(indexOfPx > -1)
   result = parseInt(pixels.substr(0, indexOfPx)) * 72 / 96;
  else
   result = parseInt(pixels) * 72 / 96;
  if(addPt)
   result = result + "pt";
 } catch(e) {}
 return result;         
}
ASPx.PxToInt = function(px) {
 return pxToNumber(px, parseInt);
}
ASPx.PxToFloat = function(px) {
 return pxToNumber(px, parseFloat);
}
function pxToNumber(px, parseFunction) {
 var result = 0;
 if(px != null && px != "") {
  try {
   var indexOfPx = px.indexOf("px");
   if(indexOfPx > -1)
    result = parseFunction(px.substr(0, indexOfPx));
  } catch(e) { }
 }
 return result;
}
ASPx.PercentageToFloat = function(perc) {
 var result = 0;
 if(perc != null && perc != "") {
  try {
   var indexOfPerc = perc.indexOf("%");
   if(indexOfPerc > -1)
    result = parseFloat(perc.substr(0, indexOfPerc)) / 100;
  } catch(e) { }
 }
 return result;
}
ASPx.CreateGuid = function() {
 return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) { 
   var r = Math.random()*16|0,v=c=='x'?r:r&0x3|0x8;
  return v.toString(16);
 });
}
ASPx.GetLeftRightBordersAndPaddingsSummaryValue = function(element, currentStyle) {
 return ASPx.GetLeftRightPaddings(element, currentStyle) + ASPx.GetHorizontalBordersWidth(element, currentStyle);
}
ASPx.GetTopBottomBordersAndPaddingsSummaryValue = function(element, currentStyle) {
 return ASPx.GetTopBottomPaddings(element, currentStyle) + ASPx.GetVerticalBordersWidth(element, currentStyle);
}
ASPx.GetVerticalBordersWidth = function(element, style) {
 if(!ASPx.IsExists(style))
  style = (Browser.IE && Browser.MajorVersion != 9 && window.getComputedStyle) ? window.getComputedStyle(element) : ASPx.GetCurrentStyle(element);
 var res = 0;
 if(style.borderTopStyle != "none") {
  res += ASPx.PxToFloat(style.borderTopWidth);
  if(Browser.IE && Browser.MajorVersion < 9)
   res += getIe8BorderWidthFromText(style.borderTopWidth);
 }
 if(style.borderBottomStyle != "none") {
  res += ASPx.PxToFloat(style.borderBottomWidth);
  if(Browser.IE && Browser.MajorVersion < 9)
   res += getIe8BorderWidthFromText(style.borderBottomWidth);
 }
 return res;
}
ASPx.GetHorizontalBordersWidth = function(element, style) {
 if(!ASPx.IsExists(style))
  style = (Browser.IE && window.getComputedStyle) ? window.getComputedStyle(element) : ASPx.GetCurrentStyle(element);
 var res = 0;
 if(style.borderLeftStyle != "none") {
  res += ASPx.PxToFloat(style.borderLeftWidth);
  if(Browser.IE && Browser.MajorVersion < 9)
   res += getIe8BorderWidthFromText(style.borderLeftWidth);
 }
 if(style.borderRightStyle != "none") {
  res += ASPx.PxToFloat(style.borderRightWidth);
  if(Browser.IE && Browser.MajorVersion < 9)
   res += getIe8BorderWidthFromText(style.borderRightWidth);
 }
 return res;
}
function getIe8BorderWidthFromText(textWidth) {
 var availableWidth = { "thin": 1, "medium" : 3, "thick": 5 };
 var width = availableWidth[textWidth];
 return width ? width : 0;
}
ASPx.GetTopBottomPaddings = function(element, style) {
 var currentStyle = style ? style : ASPx.GetCurrentStyle(element);
 return ASPx.PxToInt(currentStyle.paddingTop) + ASPx.PxToInt(currentStyle.paddingBottom);
}
ASPx.GetLeftRightPaddings = function(element, style) {
 var currentStyle = style ? style : ASPx.GetCurrentStyle(element);
 return ASPx.PxToInt(currentStyle.paddingLeft) + ASPx.PxToInt(currentStyle.paddingRight);
}
ASPx.GetTopBottomMargins = function(element, style) {
 var currentStyle = style ? style : ASPx.GetCurrentStyle(element);
 return ASPx.PxToInt(currentStyle.marginTop) + ASPx.PxToInt(currentStyle.marginBottom);
}
ASPx.GetLeftRightMargins = function(element, style) {
 var currentStyle = style ? style : ASPx.GetCurrentStyle(element);
 return ASPx.PxToInt(currentStyle.marginLeft) + ASPx.PxToInt(currentStyle.marginRight);
}
ASPx.GetClearClientWidth = function(element) {
 return element.offsetWidth - ASPx.GetLeftRightBordersAndPaddingsSummaryValue(element);
}
ASPx.GetClearClientHeight = function(element) {
 return element.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(element);
}
ASPx.SetOffsetWidth = function(element, widthValue, currentStyle) {
 if(!ASPx.IsExists(currentStyle))
  currentStyle = ASPx.GetCurrentStyle(element);
 var value = widthValue - ASPx.PxToInt(currentStyle.marginLeft) - ASPx.PxToInt(currentStyle.marginRight);
  value -= ASPx.GetLeftRightBordersAndPaddingsSummaryValue(element, currentStyle);
 if(value > -1)
  element.style.width = value + "px";
}
ASPx.SetOffsetHeight = function(element, heightValue, currentStyle) {
 if(!ASPx.IsExists(currentStyle))
  currentStyle = ASPx.GetCurrentStyle(element);
 var value = heightValue - ASPx.PxToInt(currentStyle.marginTop) - ASPx.PxToInt(currentStyle.marginBottom);
  value -= ASPx.GetTopBottomBordersAndPaddingsSummaryValue(element, currentStyle);
 if(value > -1)
  element.style.height = value + "px";
}
ASPx.FindOffsetParent = function(element) {
 var currentElement = element.parentNode;
 while(ASPx.IsExistsElement(currentElement) && currentElement.tagName != "BODY") {
  if(currentElement.offsetWidth > 0 && currentElement.offsetHeight > 0)
   return currentElement;
  currentElement = currentElement.parentNode;
 }
 return document.body;
}
ASPx.GetDocumentScrollTop = function(){
 var isScrollBodyIE = Browser.IE && ASPx.GetCurrentStyle(document.body).overflow == "hidden" && document.body.scrollTop > 0;
 if(Browser.WebKitFamily || Browser.Edge || isScrollBodyIE) {
  if(Browser.MacOSMobilePlatform) 
   return window.pageYOffset;
  else 
   return document.body.scrollTop;
 }
 else
  return document.documentElement.scrollTop;
}
ASPx.SetDocumentScrollTop = function(scrollTop) {
 if(Browser.WebKitFamily || Browser.Edge) {
  if(Browser.MacOSMobilePlatform) 
   window.pageYOffset = scrollTop;
  else 
   document.body.scrollTop = scrollTop;
 }
 else
  document.documentElement.scrollTop = scrollTop;
}
ASPx.GetDocumentScrollLeft = function(){
 var isScrollBodyIE = Browser.IE && ASPx.GetCurrentStyle(document.body).overflow == "hidden" && document.body.scrollLeft > 0;
 if(Browser.WebKitFamily || Browser.Edge || isScrollBodyIE || Browser.Opera)
  return document.body.scrollLeft;
 return document.documentElement.scrollLeft;
}
ASPx.SetDocumentScrollLeft = function(scrollLeft) {
 if(Browser.WebKitFamily || Browser.Edge) {
  if(Browser.MacOSMobilePlatform)
   window.pageXOffset = scrollLeft;
  else 
   document.body.scrollLeft = scrollLeft;
 }
 else
  document.documentElement.scrollLeft = scrollLeft;
}
ASPx.GetDocumentClientWidth = function(){
 if(document.documentElement.clientWidth == 0)
  return document.body.clientWidth;
 else
  return document.documentElement.clientWidth;
}
ASPx.GetDocumentClientHeight = function() {
 if(Browser.Firefox && window.innerHeight - document.documentElement.clientHeight > ASPx.GetVerticalScrollBarWidth()) {
  return window.innerHeight;
 } else if(Browser.Opera && Browser.Version < 9.6 || document.documentElement.clientHeight == 0) {
   return document.body.clientHeight
 }
 return document.documentElement.clientHeight;
}
ASPx.GetDocumentWidth = function(){
 var bodyWidth = document.body.offsetWidth;
 var docWidth = Browser.IE ? document.documentElement.clientWidth : document.documentElement.offsetWidth;
 var bodyScrollWidth = document.body.scrollWidth;
 var docScrollWidth = document.documentElement.scrollWidth;
 return getMaxDimensionOf(bodyWidth, docWidth, bodyScrollWidth, docScrollWidth);
}
ASPx.GetDocumentHeight = function(){
 var bodyHeight = document.body.offsetHeight;
 var docHeight = Browser.IE ? document.documentElement.clientHeight : document.documentElement.offsetHeight;
 var bodyScrollHeight = document.body.scrollHeight;
 var docScrollHeight = document.documentElement.scrollHeight;
 var maxHeight = getMaxDimensionOf(bodyHeight, docHeight, bodyScrollHeight, docScrollHeight);
 if(Browser.Opera && Browser.Version >= 9.6){
  if(Browser.Version < 10)
   maxHeight = getMaxDimensionOf(bodyHeight, docHeight, bodyScrollHeight);
  var visibleHeightOfDocument = document.documentElement.clientHeight;
  if(maxHeight > visibleHeightOfDocument)
   maxHeight = getMaxDimensionOf(window.outerHeight, maxHeight);
  else
   maxHeight = document.documentElement.clientHeight;
  return maxHeight;
 }
 return maxHeight;
}
ASPx.GetDocumentMaxClientWidth = function(){
 var bodyWidth = document.body.offsetWidth;
 var docWidth = document.documentElement.offsetWidth;
 var docClientWidth = document.documentElement.clientWidth;
 return getMaxDimensionOf(bodyWidth, docWidth, docClientWidth);
}
ASPx.GetDocumentMaxClientHeight = function(){
 var bodyHeight = document.body.offsetHeight;
 var docHeight = document.documentElement.offsetHeight;
 var docClientHeight = document.documentElement.clientHeight;
 return getMaxDimensionOf(bodyHeight, docHeight, docClientHeight);
}
ASPx.verticalScrollIsNotHidden = null;
ASPx.horizontalScrollIsNotHidden = null;
ASPx.GetVerticalScrollIsNotHidden = function() {
 if(!ASPx.IsExists(ASPx.verticalScrollIsNotHidden))
  ASPx.verticalScrollIsNotHidden = ASPx.GetCurrentStyle(document.body).overflowY !== "hidden"
   && ASPx.GetCurrentStyle(document.documentElement).overflowY !== "hidden";
 return ASPx.verticalScrollIsNotHidden;
}
ASPx.GetHorizontalScrollIsNotHidden = function() {
 if(!ASPx.IsExists(ASPx.horizontalScrollIsNotHidden))
  ASPx.horizontalScrollIsNotHidden = ASPx.GetCurrentStyle(document.body).overflowX !== "hidden"
   && ASPx.GetCurrentStyle(document.documentElement).overflowX !== "hidden";
 return ASPx.horizontalScrollIsNotHidden;
}
ASPx.GetCurrentDocumentWidth = function() {
 var result = ASPx.GetDocumentClientWidth();
 if(!ASPx.Browser.Safari && ASPx.GetVerticalScrollIsNotHidden() && ASPx.GetDocumentHeight() > ASPx.GetDocumentClientHeight())
  result += ASPx.GetVerticalScrollBarWidth();
 return result;
}
ASPx.GetCurrentDocumentHeight = function() {
 var result = ASPx.GetDocumentClientHeight();
 if(!ASPx.Browser.Safari && ASPx.GetHorizontalScrollIsNotHidden() && ASPx.GetDocumentWidth() > ASPx.GetDocumentClientWidth())
  result += ASPx.GetVerticalScrollBarWidth();
 return result;
}
function getMaxDimensionOf(){
 var max = ASPx.InvalidDimension;
 for(var i = 0; i < arguments.length; i++){
  if(max < arguments[i])
   max = arguments[i];
 }
 return max;
}
ASPx.GetClientLeft = function(element){
 return ASPx.IsExists(element.clientLeft) ? element.clientLeft : (element.offsetWidth - element.clientWidth) / 2;
}
ASPx.GetClientTop = function(element){
 return ASPx.IsExists(element.clientTop) ? element.clientTop : (element.offsetHeight - element.clientHeight) / 2;
}
ASPx.SetStyles = function(element, styles, makeImportant) {
 if(ASPx.IsExists(styles.cssText))
  element.style.cssText = styles.cssText;
 if(ASPx.IsExists(styles.className))
  element.className = styles.className;
 for(var property in styles) {
  if(!styles.hasOwnProperty(property))
   continue;
  var value = styles[property];
  switch (property) {
   case "cssText":
   case "className":
    break;
   case "float":
    ASPx.SetElementFloat(element, value);
    break;
   case "opacity":
    ASPx.SetElementOpacity(element, value);
    break;
   case "zIndex":
    ASPx.SetStylesCore(element, property, value, makeImportant);
    break;
   case "fontWeight":
    if(ASPx.Browser.IE && ASPx.Browser.Version < 9 && typeof(styles[property]) == "number")
     value = styles[property].toString();
   default:
    ASPx.SetStylesCore(element, property, value + (typeof (value) == "number" ? "px" : ""), makeImportant);
  }
 }
}
ASPx.SetStylesCore = function(element, property, value, makeImportant) {
 if(makeImportant) {
  var index = property.search("[A-Z]");
  if(index != -1)
   property = property.replace(property.charAt(index), "-" + property.charAt(index).toLowerCase());
  if(element.style.setProperty)
   element.style.setProperty(property, value, "important");
  else 
   element.style.cssText += ";" + property + ":" + value + "!important";
 }
 else
  element.style[property] = value;
}
ASPx.RemoveBordersAndShadows = function(el) {
 if(!el || !el.style)
  return;
 el.style.borderWidth = 0;
 if(ASPx.IsExists(el.style.boxShadow))
  el.style.boxShadow = "none";
 else if(ASPx.IsExists(el.style.MozBoxShadow))
  el.style.MozBoxShadow = "none";
 else if(ASPx.IsExists(el.style.webkitBoxShadow))
  el.style.webkitBoxShadow = "none";
}
ASPx.GetCellSpacing = function(element) {
 var val = parseInt(element.cellSpacing);
 if(!isNaN(val)) return val;
 val = parseInt(ASPx.GetCurrentStyle(element).borderSpacing);
 if(!isNaN(val)) return val;
 return 0;
}
ASPx.GetInnerScrollPositions = function(element) {
 var scrolls = [];
 getInnerScrollPositionsCore(element, scrolls);
 return scrolls;
}
function getInnerScrollPositionsCore(element, scrolls) {
 for(var child = element.firstChild; child; child = child.nextSibling) {
  var scrollTop = child.scrollTop,
   scrollLeft = child.scrollLeft;
  if(scrollTop > 0 || scrollLeft > 0)
   scrolls.push([child, scrollTop, scrollLeft]);
  getInnerScrollPositionsCore(child, scrolls);
 }
}
ASPx.RestoreInnerScrollPositions = function(scrolls) {
 for(var i = 0, scrollArr; scrollArr = scrolls[i]; i++) {
  if(scrollArr[1] > 0)
   scrollArr[0].scrollTop = scrollArr[1];
  if(scrollArr[2] > 0)
   scrollArr[0].scrollLeft = scrollArr[2];
 }
}
ASPx.GetOuterScrollPosition = function(element) {
 while(element.tagName !== "BODY") {
  var scrollTop = element.scrollTop,
   scrollLeft = element.scrollLeft;
  if(scrollTop > 0 || scrollLeft > 0) {
   return {
    scrollTop: scrollTop,
    scrollLeft: scrollLeft,
    element: element
   };
  }
  element = element.parentNode;
 }
 return {
  scrollTop: ASPx.GetDocumentScrollTop(),
  scrollLeft: ASPx.GetDocumentScrollLeft()
 };
}
ASPx.RestoreOuterScrollPosition = function(scrollInfo) {
 if(scrollInfo.element) {
  if(scrollInfo.scrollTop > 0)
   scrollInfo.element.scrollTop = scrollInfo.scrollTop;
  if(scrollInfo.scrollLeft > 0)
   scrollInfo.element.scrollLeft = scrollInfo.scrollLeft;
 }
 else {
  if(scrollInfo.scrollTop > 0)
   ASPx.SetDocumentScrollTop(scrollInfo.scrollTop);
  if(scrollInfo.scrollLeft > 0)
   ASPx.SetDocumentScrollLeft(scrollInfo.scrollLeft);
 }
}
ASPx.ChangeElementContainer = function(element, container, savePreviousContainer) {
 if(element.parentNode != container) {
  var parentNode = element.parentNode;
  parentNode.removeChild(element);
  container.appendChild(element);
  if(savePreviousContainer)
   element.previousContainer = parentNode;
 }
}
ASPx.RestoreElementContainer = function(element) {
 if(element.previousContainer) {
  ASPx.ChangeElementContainer(element, element.previousContainer, false);
  element.previousContainer = null;
 }
}
ASPx.MoveChildrenToElement = function(sourceElement, destinationElement){
 while(sourceElement.childNodes.length > 0)
  destinationElement.appendChild(sourceElement.childNodes[0]);
}
ASPx.GetScriptCode = function(script) {
 var useFirstChildElement = Browser.Chrome && Browser.Version < 11 || Browser.Safari && Browser.Version < 5; 
 var text = useFirstChildElement ? script.firstChild.data : script.text;
 var comment = "<!--";
 var pos = text.indexOf(comment);
 if(pos > -1)
  text = text.substr(pos + comment.length);
 return text;
}
ASPx.AppendScript = function(script) {
 var parent = document.getElementsByTagName("head")[0];
 if(!parent)
  parent = document.body;
 if(parent)
  parent.appendChild(script);
}
function getFrame(frames, name) {
 if(frames[name])
  return frames[name];
 for(var i = 0; i < frames.length; i++) {
  try {
   var frame = frames[i];
   if(frame.name == name) 
    return frame; 
   frame = getFrame(frame.frames, name);
   if(frame != null)   
    return frame; 
  } catch(e) {
  } 
 }
 return null;
}
ASPx.IsValidElement = function(element) {
 if(!element) 
  return false;
 if(!(Browser.Firefox && Browser.Version < 4)) {
  if(element.ownerDocument && element.ownerDocument.body && element.ownerDocument.body.compareDocumentPosition)
   return element.ownerDocument.body.compareDocumentPosition(element) % 2 === 0;
 }
 if(!Browser.Opera && !(Browser.IE && Browser.Version < 9) && element.offsetParent && element.parentNode.tagName)
  return true;
 while(element != null){
  if(element.tagName == "BODY")
   return true;
  element = element.parentNode;
 }
 return false;
}
ASPx.IsValidElements = function(elements) {
 if(!elements)
  return false; 
 for(var i = 0; i < elements.length; i++) {
  if(elements[i] && !ASPx.IsValidElement(elements[i]))
   return false;
 }
 return true;
}
ASPx.IsExistsElement = function(element) {
 return element && ASPx.IsValidElement(element);
}
ASPx.CreateHtmlElementFromString = function(str) {
 var dummy = ASPx.CreateHtmlElement();
 dummy.innerHTML = str;
 return dummy.firstChild;
}
ASPx.CreateHtmlElement = function(tagName, styles) {
 var element = document.createElement(tagName || "DIV");
 if(styles)
  ASPx.SetStyles(element, styles);
 return element;
}
ASPx.RestoreElementOriginalWidth = function(element) {
 if(!ASPx.IsExistsElement(element)) 
  return;
 element.style.width = element.dxOrigWidth = ASPx.GetElementOriginalWidth(element);
}
ASPx.GetElementOriginalWidth = function(element) {
 if(!ASPx.IsExistsElement(element)) 
  return null;
 var width;
 if(!ASPx.IsExists(element.dxOrigWidth)) {
   width = String(element.style.width).length > 0
  ? element.style.width
  : element.offsetWidth + "px";
 } else {
  width = element.dxOrigWidth;
 }
 return width;
}
ASPx.DropElementOriginalWidth = function(element) {
 if(ASPx.IsExists(element.dxOrigWidth))
  element.dxOrigWidth = null;
}
ASPx.GetObjectKeys = function(obj) {
 if(!obj) return [ ];
 if(Object.keys)
  return Object.keys(obj);
 var keys = [ ];
 for(var key in obj) {
  if(obj.hasOwnProperty(key))
   keys.push(key);
 }
 return keys;
}
ASPx.ShowErrorAlert = function(message) {
 var textArea = document.createElement("TEXTAREA");
 textArea.innerHTML = message;
 message = textArea.value;
 if(ASPx.IsExists(message) && message !== "")
  alert(message);
};
ASPx.ShowKBErrorMessage = function(text, kbid) {
 var console = window.console;
 if(!console || !ASPx.IsFunction(console.error))
  return;
 console.error(text + "https://www.devexpress.com/kbid=" + kbid + ".");
};
ASPx.IsInteractiveControl = function(element, extremeParent) { 
 return Data.ArrayIndexOf(["A", "INPUT", "SELECT", "OPTION", "TEXTAREA", "BUTTON", "IFRAME"], element.tagName) > -1;
}
ASPx.IsUrlContainsClientScript = function(url) {
 return url.toLowerCase().indexOf("javascript:") !== -1;
}
Function.prototype.aspxBind = function(scope) {
 var func = this;
 return function() {
  return func.apply(scope, arguments);
 };
};
var FilteringUtils = { };
FilteringUtils.EventKeyCodeChangesTheInput = function(evt) {
 if(ASPx.IsPasteShortcut(evt))
  return true;
 else if(evt.ctrlKey && !evt.altKey)
  return false;
 if(ASPx.Browser.AndroidMobilePlatform || ASPx.Browser.MacOSMobilePlatform) return true; 
 var keyCode = ASPx.Evt.GetKeyCode(evt);
 var isSystemKey = ASPx.Key.Windows <= keyCode && keyCode <= ASPx.Key.ContextMenu;
 var isFKey = ASPx.Key.F1 <= keyCode && keyCode <= 127; 
 return ASPx.Key.Delete <= keyCode && !isSystemKey && !isFKey || keyCode == ASPx.Key.Backspace || keyCode == ASPx.Key.Space;
}
FilteringUtils.FormatCallbackArg = function(prefix, arg) {
 return (ASPx.IsExists(arg) ? prefix + "|" + arg.length + ';' + arg + ';' : "");
}
ASPx.FilteringUtils = FilteringUtils;
var FormatStringHelper = { };
FormatStringHelper.PlaceHolderTemplateStruct = function(startIndex, length, index, placeHolderString){
 this.startIndex = startIndex;
 this.realStartIndex = 0;
 this.length = length;
 this.realLength = 0;
 this.index = index;
 this.placeHolderString = placeHolderString;
}
FormatStringHelper.GetPlaceHolderTemplates = function(formatString){
 formatString = this.CollapseDoubleBrackets(formatString);
 var templates = this.CreatePlaceHolderTemplates(formatString);
 return templates;
}
FormatStringHelper.CreatePlaceHolderTemplates = function(formatString){
 var templates = [];
 var templateStrings = formatString.match(/{[^}]+}/g);
 if(templateStrings != null){
  var pos = 0;
  for(var i = 0; i < templateStrings.length; i++){
   var tempString = templateStrings[i];
   var startIndex = formatString.indexOf(tempString, pos);
   var length = tempString.length;
   var indexString = tempString.slice(1).match(/^[0-9]+/);
   var index = parseInt(indexString);
   templates.push(new this.PlaceHolderTemplateStruct(startIndex, length, index, tempString));
   pos = startIndex + length;
  }
 }
 return templates;
}
FormatStringHelper.CollapseDoubleBrackets = function(formatString){
 formatString = this.CollapseOpenDoubleBrackets(formatString);
 formatString = this.CollapseCloseDoubleBrackets(formatString);
 return formatString;
}
FormatStringHelper.CollapseOpenDoubleBrackets = function(formatString){
 return formatString.replace(/{{/g, "_");
}
FormatStringHelper.CollapseCloseDoubleBrackets = function(formatString){
 while(true){
  var index = formatString.lastIndexOf("}}");
  if(index == -1) 
   break;
  else
   formatString = formatString.substr(0, index) + "_" + formatString.substr(index + 2);
 }
 return formatString;
}
ASPx.FormatStringHelper = FormatStringHelper;
var StartWithFilteringUtils = { };
StartWithFilteringUtils.HighlightSuggestedText = function(input, suggestedText, control){
 if(this.NeedToLockAndoidKeyEvents(control))
  control.LockAndroidKeyEvents();
 var selInfo = ASPx.Selection.GetInfo(input);
 var currentTextLenght = ASPx.Str.GetCoincideCharCount(suggestedText, input.value, 
  function(text, filter) { 
   return text.indexOf(filter) == 0;
  });
 var suggestedTextLenght = suggestedText.length;
 var isSelected = selInfo.startPos == 0 && selInfo.endPos == currentTextLenght && 
  selInfo.endPos == suggestedTextLenght && input.value == suggestedText;
 if(!isSelected) { 
  input.value = suggestedText;
  if(this.NeedToLockAndoidKeyEvents(control)) {
   window.setTimeout(function() {
    this.SelectText(input, currentTextLenght, suggestedTextLenght);
    control.UnlockAndroidKeyEvents();
   }.aspxBind(this), control.adroidSamsungBugTimeout);
  } else
   this.SelectText(input, currentTextLenght, suggestedTextLenght);
 }
}
StartWithFilteringUtils.SelectText = function(input, startPos, stopPos) {
 if(startPos < stopPos)
  ASPx.Selection.Set(input, startPos, stopPos);
}
StartWithFilteringUtils.RollbackOneSuggestedChar = function(input){
 var currentText = input.value;
 var cutText = currentText.slice(0, -1);
 if(cutText != currentText)
  input.value = cutText;
}
StartWithFilteringUtils.NeedToLockAndoidKeyEvents = function(control) {
 return ASPx.Browser.AndroidMobilePlatform && control && control.LockAndroidKeyEvents;
}
ASPx.StartWithFilteringUtils = StartWithFilteringUtils;
var ContainsFilteringUtils = { };
ContainsFilteringUtils.ColumnSelectionStruct = function(index, startIndex, length){
 this.index = index;
 this.length = length;
 this.startIndex = startIndex;
}
ContainsFilteringUtils.IsFilterCrossPlaseHolder = function(filterStartIndex, filterEndIndex, template) {
 var left = Math.max(filterStartIndex, template.realStartIndex);
 var right = Math.min(filterEndIndex,  template.realStartIndex + template.realLength);
 return left < right;
}
ContainsFilteringUtils.GetColumnSelectionsForItem = function(itemValues, formatString, filterString) {
 if(formatString == "") 
  return this.GetSelectionForSingleColumnItem(itemValues, filterString); 
 var result = [];
 var formatedString = ASPx.Formatter.Format(formatString, itemValues);
 var filterStartIndex = ASPx.Str.PrepareStringForFilter(formatedString).indexOf(ASPx.Str.PrepareStringForFilter(filterString));
 if(filterStartIndex == -1) return result;
 var filterEndIndex = filterStartIndex + filterString.length;
 var templates = FormatStringHelper.GetPlaceHolderTemplates(formatString);
 this.SupplyTemplatesWithRealValues(itemValues, templates);
 for(var i = 0; i < templates.length ; i++) {
  if(this.IsFilterCrossPlaseHolder(filterStartIndex, filterEndIndex, templates[i])) 
   result.push(this.GetColumnSelectionsForItemValue(templates[i], filterStartIndex, filterEndIndex));
 }
 return result;
}
ContainsFilteringUtils.GetColumnSelectionsForItemValue = function(template, filterStartIndex, filterEndIndex) {
 var selectedTextStartIndex = filterStartIndex < template.realStartIndex ? 0 :
  filterStartIndex - template.realStartIndex;
 var selectedTextEndIndex = filterEndIndex >  template.realStartIndex + template.realLength ? template.realLength :
  filterEndIndex - template.realStartIndex;
 var selectedTextLength = selectedTextEndIndex - selectedTextStartIndex;
  return new this.ColumnSelectionStruct(template.index, selectedTextStartIndex, selectedTextLength);
},
ContainsFilteringUtils.GetSelectionForSingleColumnItem = function(itemValues, filterString) {
 var selectedTextStartIndex = ASPx.Str.PrepareStringForFilter(itemValues[0]).indexOf(ASPx.Str.PrepareStringForFilter(filterString));
 var selectedTextLength = filterString.length;
 return [new this.ColumnSelectionStruct(0, selectedTextStartIndex, selectedTextLength)];
}
ContainsFilteringUtils.ResetFormatStringIndex = function(formatString, index) {
 if(index != 0)
  return formatString.replace(index.toString(), "0");
 return formatString;
},
ContainsFilteringUtils.SupplyTemplatesWithRealValues = function(itemValues, templates) {
 var shift = 0;
 for(var i = 0; i < templates.length; i++) {
  var formatString = this.ResetFormatStringIndex(templates[i].placeHolderString, templates[i].index);
  var currentItemValue = itemValues[templates[i].index];
  templates[i].realLength = ASPx.Formatter.Format(formatString, currentItemValue).length;
  templates[i].realStartIndex  += templates[i].startIndex + shift; 
  shift += templates[i].realLength - templates[i].placeHolderString.length; 
 }
}
ContainsFilteringUtils.PrepareElementText = function(itemText) {
 return itemText ? itemText.replace(/\&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;") : '';
}
ContainsFilteringUtils.UnselectContainsTextInElement = function(element, selection, highlightTagName) {
 var currentText =  ASPx.Attr.GetAttribute (element, "DXText");
 if(ASPx.IsExists(currentText)) {
  currentText = ContainsFilteringUtils.PrepareElementText(currentText);
  ASPx.SetInnerHtml(element, currentText === "" ? "&nbsp;" : currentText);
 }
}
ContainsFilteringUtils.ReselectContainsTextInElement = function(element, selection, highlightTagName) {
 var currentText = ASPx.GetInnerText(element);
 if(!highlightTagName)
  highlightTagName = "em";
 highlightTagName = highlightTagName.toLowerCase();
 if(currentText.indexOf("</" + highlightTagName + ">") != -1)
  ContainsFilteringUtils.UnselectContainsTextInElement(element, selection, highlightTagName);
 return ContainsFilteringUtils.SelectContainsTextInElement(element, selection, highlightTagName);
}
ContainsFilteringUtils.SelectContainsTextInElement = function(element, selection, highlightTagName) {
 if(selection.startIndex == -1)
  return;
 var currentText =  ASPx.Attr.GetAttribute (element, "DXText");
 if(!ASPx.IsExists(currentText)) ASPx.Attr.SetAttribute (element, "DXText", ASPx.GetInnerText(element));
 if(!highlightTagName)
  highlightTagName = "em";
 highlightTagName = highlightTagName.toLowerCase();
 var oldInnerText = ASPx.GetInnerText(element);
 var newInnerText = ContainsFilteringUtils.PrepareElementText(oldInnerText.substr(0, selection.startIndex)) + "<" + highlightTagName + ">" +
      oldInnerText.substr(selection.startIndex, selection.length) + "</" + highlightTagName + ">" +
      ContainsFilteringUtils.PrepareElementText(oldInnerText.substr(selection.startIndex + selection.length));
 ASPx.SetInnerHtml(element, newInnerText);
}
ASPx.ContainsFilteringUtils = ContainsFilteringUtils;
ASPx.MakeEqualControlsWidth = function(name1, name2){
 var control1 = ASPx.GetControlCollection().Get(name1);
 var control2 = ASPx.GetControlCollection().Get(name2);
 if(control1 && control2){
  var width = Math.max(control1.GetWidth(), control2.GetWidth());
  control1.SetWidth(width);
  control2.SetWidth(width);
 }
}
var AccessibilityUtils = {
 isInitialized: false,
 highContrastCssClassMarker: "dxHighContrast",
 highContrastThemeActive: false,
 accessibleBackgroundCssMarker: ".dx-runtime-background",
 createAccessibleBackgrounds: function(control) {
  if(!this.highContrastThemeActive || control.accessibleBackgroundsCreated || !control.accessibilityCompliant)
   return;
  var className = this.accessibleBackgroundCssMarker;
  var styleSheetRuleNames = [];
  iterateStyleSheetRules(null, function(rule) {
   var selectorTxt = rule.selectorText;
   if(selectorTxt && selectorTxt.indexOf(className) > -1)
    styleSheetRuleNames.push(ASPx.Str.CompleteReplace(selectorTxt, className, "")); 
  });
  for(var i = 0; i < styleSheetRuleNames.length; i++) {
   var name = styleSheetRuleNames[i];
   var rule = ASPx.GetStyleSheetRules(name.substring(1));
   if(rule && rule.style && rule.style.backgroundImage)
    this.createAccessibleBackground(control.GetMainElement(), rule.style, name);
  }
  control.accessibleBackgroundsCreated = true;
 },
 createAccessibleBackground: function(container, style, selector) {
  if(!container)
   return;
  var backgroundUrl = style.backgroundImage.substring(5, style.backgroundImage.length - 2);
  var elements = container.querySelectorAll(selector);
  var accessibleBackgroundClassName = "dx-acc-bi";
  for(var i = 0; i < elements.length; i++) {
   var element = elements[i];
   if(ASPx.ElementHasCssClass(element, accessibleBackgroundClassName))
    continue;
   var image = null;
   if(element.tagName !== "IMG") {
    ASPx.AddClassNameToElement(element, accessibleBackgroundClassName);
    image = element.ownerDocument.createElement("IMG");
    ASPx.SetStyles(image, { width: element.offsetWidth, height: element.offsetHeight });
    if(element.firstChild)
     element.insertBefore(image, element.firstChild);
    else
     element.appendChild(image);
   } else
    image = element;
   image.src = backgroundUrl;
  }
 },
 initialize: function() {
  if(!this.isInitialized) {
   this.isInitialized = true;
   this.detectHighContrastTheme();
  }   
 },
 detectHighContrastTheme: function() {
  var testElement = document.createElement("DIV");
  ASPx.SetStyles(testElement, {
   backgroundImage: "url('" + ASPx.EmptyImageUrl + "')",
   display: "none"
  }, true);
  var docElement = document.documentElement;
  docElement.appendChild(testElement);
  var actualBackgroundImg = ASPx.GetCurrentStyle(testElement).backgroundImage;
  docElement.removeChild(testElement);
  if(actualBackgroundImg === "none") {
   this.highContrastThemeActive = true;
   ASPx.AddClassNameToElement(docElement, this.highContrastCssClassMarker);
  }
 }
};
ASPx.AccessibilityUtils = AccessibilityUtils;
ASPx.AccessibilityUtils.SendMessageToAssistiveTechnology = function(message) {
 var messageParts = ASPx.Ident.IsArray(message) ? message : [message];
 var args = new ASPxClientControlBeforePronounceEventArgs(messageParts, null);
 ASPx.AccessibilityPronouncer.EnsureInitialize();
 ASPx.AccessibilityPronouncer.Pronounce(args, ASPx.AccessibilityPronouncerType.live);
};
ASPx.AccessibilityUtils.SetFocusAccessible = function(focusableElement) {
 if(!focusableElement)
  return;
 var elementId = focusableElement.id;
 if(!elementId) {
  var namedParent = ASPx.GetParent(focusableElement, function(element) {
   return !!element.id;
  });
  if(ASPx.IsExists(namedParent))
   elementId = namedParent.id;
 }
 var focusableControl = ASPx.GetClientControlByElementID(elementId);
 if(focusableControl && focusableControl.OnAssociatedLabelClick)
  focusableControl.OnAssociatedLabelClick(focusableElement);
 else
  window.setTimeout(function() {
   ASPx.AccessibilityUtils.SetFocusAccessibleCore(focusableElement);
  }, 0);
}
ASPx.AccessibilityUtils.SetFocusAccessibleCore = function(focusableElement) {
 if(!ASPx.IsExists(focusableElement))
  return;
 if(!ASPx.IsValidElement(focusableElement) && focusableElement.id)
  focusableElement = ASPx.GetElementById(focusableElement.id);
 if(!ASPx.IsActionElement(focusableElement))
  focusableElement = ASPx.RestoreFocusHelper.findNeighbourFocusElement(focusableElement, document.body);
 if(ASPx.IsExistsElement(focusableElement))
  focusableElement.focus();
}
ASPx.EnableCssAnimation = true;
var AnimationTransitionBase = ASPx.CreateClass(null, {
 constructor: function(element, options) {
  if(element) {
   AnimationTransitionBase.Cancel(element);
   this.element = element;
   this.element.aspxTransition = this;
  }
  this.duration = options.duration || AnimationConstants.Durations.DEFAULT;
  this.transition = options.transition || AnimationConstants.Transitions.SINE;
  this.property = options.property;
  this.unit = options.unit || "";
  this.onComplete = options.onComplete;
  this.to = null;
  this.from = null;
 },
 Start: function(from, to) {
  if(to != undefined) {
   this.to = to;
   this.from = from;
   this.SetValue(this.from);
  }
  else
   this.to = from;
 },
 Cancel: function() {
  if(!this.element)
   return;
  try {
   delete this.element.aspxTransition;
  } catch(e) {
   this.element.aspxTransition = undefined;
  }
 },
 GetValue: function() {
  return this.getValueInternal(this.element, this.property);
 },
 SetValue: function(value) {
  this.setValueInternal(this.element, this.property, this.unit, value);
 },
 setValueInternal: function(element, property, unit, value) {
  if(property == "opacity")
   AnimationUtils.setOpacity(element, value);
  else
   element.style[property] = value + unit;
 },
 getValueInternal: function(element, property) {
  if(property == "opacity")
   return ASPx.GetElementOpacity(element);
  var value = parseFloat(element.style[property]);
  return isNaN(value) ? 0 : value;
 },
 performOnComplete: function() {
  if(this.onComplete)
   this.onComplete(this.element);
 },
 getTransition: function() {
  return this.transition;
 }
});
AnimationTransitionBase.Cancel = function(element) {
 if(element.aspxTransition)
  element.aspxTransition.Cancel();
};
var AnimationConstants = {};
AnimationConstants.Durations = {
 SHORT: 200,
 DEFAULT: 400,
 LONG: 600
};
AnimationConstants.Transitions = {
 LINER: {
  Css: "cubic-bezier(0.250, 0.250, 0.750, 0.750)",
  Js: function(progress) { return progress; }
 },
 SINE: {
  Css: "cubic-bezier(0.470, 0.000, 0.745, 0.715)",
  Js: function(progress) { return Math.sin(progress * 1.57); }
 },
 POW: {
  Css: "cubic-bezier(0.755, 0.050, 0.855, 0.060)",
  Js: function(progress) { return Math.pow(progress, 4); }
 },
 POW_EASE_OUT: {
  Css: "cubic-bezier(0.165, 0.840, 0.440, 1.000)",
  Js: function(progress) { return 1 - AnimationConstants.Transitions.POW.Js(1 - progress); }
 },
 RIPPLE: {
  Css: "cubic-bezier(0.47, 0.06, 0.23, 0.99)",
  Js: function(progress) {
   return Math.pow((progress), 3) * 0.47 + 3 * progress * Math.pow((1 - progress), 2) * 0.06 + 3 * Math.pow(progress, 2) *
    (1 - progress) * 0.23 + 0.99 * Math.pow(progress, 3);
  }
 }
};
var JsAnimationTransition = ASPx.CreateClass(AnimationTransitionBase, {
 constructor: function(element, options) {
  this.constructor.prototype.constructor.call(this, element, options);
  this.onStep = options.onStep;
  this.fps = 60;
  this.startTime = null;
 },
 Start: function(from, to) {
  if(from == to) {
   this.from = this.to = from;
   setTimeout(this.complete.aspxBind(this), 0);
  }
  else {
   AnimationTransitionBase.prototype.Start.call(this, from, to);
   if(to == undefined)
    this.from = this.GetValue();
   this.initTimer();
  }
 },
 Cancel: function() {
  AnimationTransitionBase.prototype.Cancel.call(this);
  if(this.timerId)
   clearInterval(this.timerId);
 },
 initTimer: function() {
  this.startTime = new Date();
  this.timerId = window.setInterval(function() { this.onTick(); }.aspxBind(this), 1000 / this.fps);
 },
 onTick: function() {
  var progress = (new Date() - this.startTime) / this.duration;
  if(progress >= 1)
   this.complete();
  else {
   this.update(progress);
   if(this.onStep)
    this.onStep();
  }
 },
 update: function(progress) {
  this.SetValue(this.gatCalculatedValue(this.from, this.to, progress));
 },
 complete: function() {
  this.Cancel();
  this.update(1);
  this.performOnComplete();
 },
 gatCalculatedValue: function(from, to, progress) {
  if(progress == 1)
   return to;
  return from + (to - from) * this.getTransition()(progress);
 },
 getTransition: function() {
  return this.transition.Js;
 }
});
var SimpleAnimationTransition = ASPx.CreateClass(JsAnimationTransition, {
 constructor: function(options) {
  this.constructor.prototype.constructor.call(this, null, options);
  this.transition = options.transition || AnimationConstants.Transitions.POW_EASE_OUT;
  this.onUpdate = options.onUpdate;
  this.lastValue = 0;
 },
 SetValue: function(value) {
  this.onUpdate(value - this.lastValue);
  this.lastValue = value;
 },
 GetValue: function() {
  return this.lastValue;
 },
 performOnComplete: function() {
  if(this.onComplete)
   this.onComplete();
 }
});
var MultipleJsAnimationTransition = ASPx.CreateClass(JsAnimationTransition, {
 constructor: function(element, options) {
  this.constructor.prototype.constructor.call(this, element, options);
  this.properties = {};
 },
 Start: function(properties) {
  this.initProperties(properties);
  this.initTimer();
 },
 initProperties: function(properties) {
  this.properties = properties;
  for(var propName in this.properties)
   if(properties[propName].from == undefined)
    properties[propName].from = this.getValueInternal(this.element, propName);
 },
 update: function(progress) {
  for(var propName in this.properties) {
   var property = this.properties[propName];
   if(property.from != property.to)
    this.setValueInternal(this.element, propName, property.unit, this.gatCalculatedValue(property.from, property.to, progress));
  }
 }
});
var CssAnimationTransition = ASPx.CreateClass(AnimationTransitionBase, {
 constructor: function(element, options) {
  this.constructor.prototype.constructor.call(this, element, options);
  this.transitionPropertyName = AnimationUtils.CurrentTransition.property;
  this.eventName = AnimationUtils.CurrentTransition.event;
 },
 Start: function(from, to) {
  AnimationTransitionBase.prototype.Start.call(this, from, to);
  this.startTimerId = window.setTimeout(function() {
   if(this.from == this.to)
    this.onTransitionEnd();
   else {
    var isHidden = this.element.offsetHeight == 0 && this.element.offsetWidth == 0; 
    if(!isHidden)
     this.prepareElementBeforeAnimation();
    this.SetValue(this.to);
    if(isHidden)
     this.onTransitionEnd();
   }
  }.aspxBind(this), 0);
 },
 Cancel: function() {
  window.clearTimeout(this.startTimerId);
  AnimationTransitionBase.prototype.Cancel.call(this);
  ASPx.Evt.DetachEventFromElement(this.element, this.eventName, CssAnimationTransition.transitionEnd);
  this.stopAnimation();
  this.setValueInternal(this.element, this.transitionPropertyName, "", "");
 },
 prepareElementBeforeAnimation: function() {
  ASPx.Evt.AttachEventToElement(this.element, this.eventName, CssAnimationTransition.transitionEnd);
  var tmpH = this.element.offsetHeight; 
  this.element.style[this.transitionPropertyName] = this.getTransitionCssString();
  if(ASPx.Browser.Safari && ASPx.Browser.MacOSMobilePlatform && ASPx.Browser.MajorVersion >= 8) 
   setTimeout(function() {
    if(this.element && this.element.aspxTransition) {
     this.element.style[this.transitionPropertyName] = "";
     this.element.aspxTransition.onTransitionEnd();
    }
   }.aspxBind(this), this.duration + 100);
 },
 stopAnimation: function() {
  this.SetValue(ASPx.GetCurrentStyle(this.element)[this.property]);
 },
 onTransitionEnd: function() {
  this.Cancel();
  this.performOnComplete();
 },
 getTransition: function() {
  return this.transition.Css;
 },
 getTransitionCssString: function() {
  return this.getTransitionCssStringInternal(this.getCssName(this.property));
 },
 getTransitionCssStringInternal: function(cssProperty) {
  return cssProperty + " " + this.duration + "ms " + this.getTransition();
 },
 getCssName: function(property) {
  switch(property) {
   case "marginLeft":
    return "margin-left";
   case "marginTop":
    return "margin-top"
  }
  return property;
 }
});
var MultipleCssAnimationTransition = ASPx.CreateClass(CssAnimationTransition, {
 constructor: function(element, options) {
  this.constructor.prototype.constructor.call(this, element, options);
  this.properties = null;
 },
 Start: function(properties) {
  this.properties = properties;
  this.forEachProperties(function(property, propName) {
   if(property.from !== undefined)
    this.setValueInternal(this.element, propName, property.unit, property.from);
  }.aspxBind(this));
  this.prepareElementBeforeAnimation();
  this.forEachProperties(function(property, propName) {
   this.setValueInternal(this.element, propName, property.unit, property.to);
  }.aspxBind(this));
 },
 stopAnimation: function() {
  var style = ASPx.GetCurrentStyle(this.element);
  this.forEachProperties(function(property, propName) {
   this.setValueInternal(this.element, propName, "", style[propName]);
  }.aspxBind(this));
 },
 getTransitionCssString: function() {
  var str = "";
  this.forEachProperties(function(property, propName) {
   str += this.getTransitionCssStringInternal(this.getCssName(propName)) + ",";
  }.aspxBind(this));
  str = str.substring(0, str.length - 1);
  return str;
 },
 forEachProperties: function(func) {
  for(var propName in this.properties) {
   var property = this.properties[propName];
   if(property.from == undefined)
    property.from = this.getValueInternal(this.element, propName);
   if(property.from != property.to)
    func(property, propName);
  }
 }
});
CssAnimationTransition.transitionEnd = function(evt) {
 var element = evt.target;
 if(element && element.aspxTransition)
  element.aspxTransition.onTransitionEnd();
}
var AnimationUtils = {
 CanUseCssTransition: function() { return ASPx.EnableCssAnimation && this.CurrentTransition },
 CanUseCssTransform: function() { return this.CanUseCssTransition() && this.CurrentTransform },
 CurrentTransition: (function() {
  if(ASPx.Browser.IE) 
   return null;
  var transitions = [
   { property: "webkitTransition", event: "webkitTransitionEnd" },
   { property: "MozTransition", event: "transitionend" },
   { property: "OTransition", event: "oTransitionEnd" },
   { property: "transition", event: "transitionend" }
  ]
  var fakeElement = document.createElement("DIV");
  for(var i = 0; i < transitions.length; i++)
   if(transitions[i].property in fakeElement.style)
    return transitions[i];
 })(),
 CurrentTransform: (function() {
  var transforms = ["transform", "MozTransform", "-webkit-transform", "msTransform", "OTransform"];
  var fakeElement = document.createElement("DIV");
  for(var i = 0; i < transforms.length; i++)
   if(transforms[i] in fakeElement.style)
    return transforms[i];
 })(),
 SetTransformValue: function(element, position, isTop) {
  if(this.CanUseCssTransform())
   element.style[this.CurrentTransform] = this.GetTransformCssText(position, isTop);
  else
   element.style[!isTop ? "left" : "top"] = position + "px";
 },
 GetTransformValue: function(element, isTop) {
  if(this.CanUseCssTransform()) {
   var cssValue = element.style[this.CurrentTransform];
   return cssValue ? Number(cssValue.replace('matrix(1, 0, 0, 1,', '').replace(')', '').split(',')[!isTop ? 0 : 1]) : 0;
  }
  else
   return !isTop ? element.offsetLeft : element.offsetTop;
 },
 GetTransformCssText: function(position, isTop) {
  return "matrix(1, 0, 0, 1," + (!isTop ? position : 0) + ", " + (!isTop ? 0 : position) + ")";
 },
 createMultipleAnimationTransition: function (element, options) {
  return this.CanUseCssTransition() && !options.onStep ? new MultipleCssAnimationTransition(element, options) : new MultipleJsAnimationTransition(element, options);
 },
 createSimpleAnimationTransition: function(options) {
  return new SimpleAnimationTransition(options);
 },
 createJsAnimationTransition: function(element, options) {
  return new JsAnimationTransition(element, options);
 },
 createCssAnimationTransition: function(element, options) {
  return new CssAnimationTransition(element, options);
 },
 setOpacity: function(element, value) {
  ASPx.SetElementOpacity(element, value);
 }
};
ASPxClientUtils = {};
ASPxClientUtils.agent = Browser.UserAgent;
ASPxClientUtils.opera = Browser.Opera;
ASPxClientUtils.opera9 = Browser.Opera && Browser.MajorVersion == 9;
ASPxClientUtils.safari = Browser.Safari;
ASPxClientUtils.safari3 = Browser.Safari && Browser.MajorVersion == 3;
ASPxClientUtils.safariMacOS = Browser.Safari && Browser.MacOSPlatform;
ASPxClientUtils.chrome = Browser.Chrome;
ASPxClientUtils.ie = Browser.IE;
;
ASPxClientUtils.ie7 = Browser.IE && Browser.MajorVersion == 7;
ASPxClientUtils.firefox = Browser.Firefox;
ASPxClientUtils.firefox3 = Browser.Firefox && Browser.MajorVersion == 3;
ASPxClientUtils.mozilla = Browser.Mozilla;
ASPxClientUtils.netscape = Browser.Netscape;
ASPxClientUtils.browserVersion = Browser.Version;
ASPxClientUtils.browserMajorVersion = Browser.MajorVersion;
ASPxClientUtils.macOSPlatform = Browser.MacOSPlatform;
ASPxClientUtils.windowsPlatform = Browser.WindowsPlatform;
ASPxClientUtils.webKitFamily = Browser.WebKitFamily;
ASPxClientUtils.netscapeFamily = Browser.NetscapeFamily;
ASPxClientUtils.touchUI = Browser.TouchUI;
ASPxClientUtils.webKitTouchUI = Browser.WebKitTouchUI;
ASPxClientUtils.msTouchUI = Browser.MSTouchUI;
ASPxClientUtils.iOSPlatform = Browser.MacOSMobilePlatform;
ASPxClientUtils.androidPlatform = Browser.AndroidMobilePlatform;
ASPxClientUtils.ArrayInsert = Data.ArrayInsert;
ASPxClientUtils.ArrayRemove = Data.ArrayRemove;
ASPxClientUtils.ArrayRemoveAt = Data.ArrayRemoveAt;
ASPxClientUtils.ArrayClear = Data.ArrayClear;
ASPxClientUtils.ArrayIndexOf = Data.ArrayIndexOf;
ASPxClientUtils.AttachEventToElement = Evt.AttachEventToElement;
ASPxClientUtils.DetachEventFromElement = Evt.DetachEventFromElement;
ASPxClientUtils.GetEventSource = Evt.GetEventSource;
ASPxClientUtils.GetEventX = Evt.GetEventX;
ASPxClientUtils.GetEventY = Evt.GetEventY;
ASPxClientUtils.GetKeyCode = Evt.GetKeyCode;
ASPxClientUtils.PreventEvent = Evt.PreventEvent;
ASPxClientUtils.PreventEventAndBubble = Evt.PreventEventAndBubble;
ASPxClientUtils.PreventDragStart = Evt.PreventDragStart;
ASPxClientUtils.ClearSelection = Selection.Clear;
ASPxClientUtils.IsExists = ASPx.IsExists;
ASPxClientUtils.IsFunction = ASPx.IsFunction;
ASPxClientUtils.GetAbsoluteX = ASPx.GetAbsoluteX;
ASPxClientUtils.GetAbsoluteY = ASPx.GetAbsoluteY;
ASPxClientUtils.SetAbsoluteX = ASPx.SetAbsoluteX;
ASPxClientUtils.SetAbsoluteY = ASPx.SetAbsoluteY;
ASPxClientUtils.GetDocumentScrollTop = ASPx.GetDocumentScrollTop;
ASPxClientUtils.GetDocumentScrollLeft = ASPx.GetDocumentScrollLeft;
ASPxClientUtils.GetDocumentClientWidth = ASPx.GetDocumentClientWidth;
ASPxClientUtils.GetDocumentClientHeight = ASPx.GetDocumentClientHeight;
ASPxClientUtils.GetIsParent = ASPx.GetIsParent;
ASPxClientUtils.GetParentById = ASPx.GetParentById;
ASPxClientUtils.GetParentByTagName = ASPx.GetParentByTagName;
ASPxClientUtils.GetParentByClassName = ASPx.GetParentByPartialClassName;
ASPxClientUtils.GetChildById = ASPx.GetChildById;
ASPxClientUtils.GetChildByTagName = ASPx.GetChildByTagName;
ASPxClientUtils.SetCookie = Cookie.SetCookie;
ASPxClientUtils.GetCookie = Cookie.GetCookie;
ASPxClientUtils.DeleteCookie = Cookie.DelCookie;
ASPxClientUtils.GetShortcutCode = ASPx.GetShortcutCode; 
ASPxClientUtils.GetShortcutCodeByEvent = ASPx.GetShortcutCodeByEvent;
ASPxClientUtils.StringToShortcutCode = ASPx.ParseShortcutString;
ASPxClientUtils.Trim = Str.Trim; 
ASPxClientUtils.TrimStart = Str.TrimStart;
ASPxClientUtils.TrimEnd = Str.TrimEnd;
ASPxClientUtils.SendMessageToAssistiveTechnology = ASPx.AccessibilityUtils.SendMessageToAssistiveTechnology;
window.ASPxClientUtils = ASPxClientUtils;
ASPx.AnimationUtils = AnimationUtils;
ASPx.AnimationTransitionBase = AnimationTransitionBase;
ASPx.AnimationConstants = AnimationConstants;
})();
   
(function () {
 if (typeof ASPx == "undefined") {
  window.ASPx = {};
 }
 ASPx.ASPxImageLoad = {};
 ASPx.ASPxImageLoad.dxDefaultLoadingImageCssClass = "dxe-loadingImage";
 ASPx.ASPxImageLoad.OnLoad = function (image, customLoadingImage, isOldIE, customBackgroundImageUrl) {
  image.dxCustomBackgroundImageUrl = "";
  image.dxShowLoadingImage = true;
  image.dxCustomLoadingImage = customLoadingImage;
  if (customBackgroundImageUrl != "")
   image.dxCustomBackgroundImageUrl = "url('" + customBackgroundImageUrl + "')";
  ASPx.ASPxImageLoad.prepareImageBackground(image, isOldIE);
  ASPx.ASPxImageLoad.removeHandlers(image);
  image.className = image.className.replace(ASPx.ASPxImageLoad.dxDefaultLoadingImageCssClass, "");
 };
 ASPx.ASPxImageLoad.removeASPxImageBackground = function (image, isOldIE) {
  if (isOldIE) 
   image.style.removeAttribute("background-image");
  else 
   image.style.backgroundImage = "";
 };
 ASPx.ASPxImageLoad.prepareImageBackground = function (image, isOldIE) {
  ASPx.ASPxImageLoad.removeASPxImageBackground(image, isOldIE);
  if (image.dxCustomBackgroundImageUrl != "")
   image.style.backgroundImage = image.dxCustomBackgroundImageUrl;
 };
 ASPx.ASPxImageLoad.removeHandlers = function (image) {
  image.removeAttribute("onload");
  image.removeAttribute("onabort");
  image.removeAttribute("onerror");
 };
})();
(function () {
ASPx.classesScriptParsed = false;
ASPx.documentLoaded = false; 
ASPx.CallbackType = {
 Data: "d",
 Common: "c"
};
ASPx.callbackState = {
 aborted: "aborted",
 inTurn: "inTurn",
 sent: "sent"
};
var ASPxClientEvent = ASPx.CreateClass(null, {
 constructor: function() {
  this.handlerInfoList = [];
  this.firingIndex = -1;
 },
 AddHandler: function(handler, executionContext) {
  if(typeof(executionContext) == "undefined")
   executionContext = null;
  this.RemoveHandler(handler, executionContext);
  var handlerInfo = ASPxClientEvent.CreateHandlerInfo(handler, executionContext);
  this.handlerInfoList.push(handlerInfo);
 },
 RemoveHandler: function(handler, executionContext) {
  this.removeHandlerByCondition(function(handlerInfo) {
   return handlerInfo.handler == handler && 
    (!executionContext || handlerInfo.executionContext == executionContext);
  });
 },
 removeHandlerByCondition: function(predicate) {
   for(var i = this.handlerInfoList.length - 1; i >= 0; i--) {
   var handlerInfo = this.handlerInfoList[i];
   if(predicate(handlerInfo)) {
    ASPx.Data.ArrayRemoveAt(this.handlerInfoList, i);
    if(i <= this.firingIndex)
     this.firingIndex--;
   }
  }
 },
 removeHandlerByControlName: function(controlName) {
  this.removeHandlerByCondition(function(handlerInfo) {
   return handlerInfo.executionContext &&  
    handlerInfo.executionContext.name === controlName;
  });
 },
 ClearHandlers: function() {
  this.handlerInfoList.length = 0;
 },
 FireEvent: function(obj, args) {
  for(this.firingIndex = 0; this.firingIndex < this.handlerInfoList.length; this.firingIndex++) {
   var handlerInfo = this.handlerInfoList[this.firingIndex];
   handlerInfo.handler.call(handlerInfo.executionContext, obj, args);
  }
 },
 InsertFirstHandler: function(handler, executionContext){
  if(typeof(executionContext) == "undefined")
   executionContext = null;
  var handlerInfo = ASPxClientEvent.CreateHandlerInfo(handler, executionContext);
  ASPx.Data.ArrayInsert(this.handlerInfoList, handlerInfo, 0);
 },
 IsEmpty: function() {
  return this.handlerInfoList.length == 0;
 }
});
ASPxClientEvent.CreateHandlerInfo = function(handler, executionContext) {
 return {
  handler: handler,
  executionContext: executionContext
 };
};
var ASPxClientEventArgs = ASPx.CreateClass(null, {
 constructor: function() {
 }
});
ASPxClientEventArgs.Empty = new ASPxClientEventArgs();
var ASPxClientCancelEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
  this.cancel = false;
 }
});
var ASPxClientProcessingModeEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(processOnServer){
  this.constructor.prototype.constructor.call(this);
  this.processOnServer = processOnServer;
 }
});
var ASPxClientProcessingModeCancelEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(processOnServer){
  this.constructor.prototype.constructor.call(this, processOnServer);
  this.cancel = false;
 }
});
var OrderedMap = ASPx.CreateClass(null, {
 constructor: function(){
  this.entries = {};
  this.firstEntry = null;
  this.lastEntry = null;
 },
 add: function(key, element) {
  var entry = this.addEntry(key, element);
  this.entries[key] = entry;
 },
 remove: function(key) {
  var entry = this.entries[key];
  if(entry === undefined)
   return;
  this.removeEntry(entry);
  delete this.entries[key];
 },
 clear: function() {
  this.markAllEntriesAsRemoved();
  this.entries = {};
  this.firstEntry = null;
  this.lastEntry = null;
 },
 get: function(key) {
  var entry = this.entries[key];
  return entry ? entry.value : undefined;
 },
 forEachEntry: function(processFunc, context) {
  context = context || this;
  for(var entry = this.firstEntry; entry; entry = entry.next) {
   if(entry.removed)
    continue;
   if(processFunc.call(context, entry.key, entry.value))
    return;
  }
 },
 addEntry: function(key, element) {
  var entry = { key: key, value: element, next: null, prev: null };
  if(!this.firstEntry)
   this.firstEntry = entry;
  else {
   entry.prev = this.lastEntry;
   this.lastEntry.next = entry;
  }
  this.lastEntry = entry;
  return entry;
 },
 removeEntry: function(entry) {
  if(this.firstEntry == entry)
   this.firstEntry = entry.next;
  if(this.lastEntry == entry)
   this.lastEntry = entry.prev;
  if(entry.prev)
   entry.prev.next = entry.next;
  if(entry.next)
   entry.next.prev = entry.prev;
  entry.removed = true;
 },
 markAllEntriesAsRemoved: function() {
  for(var entry = this.firstEntry; entry; entry = entry.next)
   entry.removed = true;
 }
});
var CollectionBase = ASPx.CreateClass(null, {
 constructor: function(){
  this.elementsMap = new OrderedMap();
  this.isASPxClientCollection = true;
 },
 Add: function(key, element) {
  this.elementsMap.add(key, element);
 },
 Remove: function(key) {
  this.elementsMap.remove(key);
 },
 Clear: function(){
  this.elementsMap.clear();
 },
 Get: function(key){
  return this.elementsMap.get(key);
 }
});
var GarbageCollector = ASPx.CreateClass(null, {
 constructor: function() {
  this.interval = 5000;
  this.intervalID = window.setInterval(function(){ this.CollectObjects(); }.aspxBind(this), this.interval);
 },
 CollectObjects: function(){
  if(ASPx.GetControlCollection().InCallback()) return;
  ASPx.GetControlCollectionCollection().RemoveDisposedControls();
  if(typeof(ASPx.GetStateController) != "undefined")
   ASPx.GetStateController().RemoveDisposedItems();
  if(ASPx.TableScrollHelperCollection)
   ASPx.TableScrollHelperCollection.RemoveDisposedObjects();
  if(ASPx.Ident.scripts.ASPxClientRatingControl)
   ASPxClientRatingControl.RemoveDisposedElementUnderCursor();
  var postHandler = aspxGetPostHandler();
  if(postHandler)
   postHandler.RemoveDisposedFormsFromCache();
 }
});
var gcCollector = new GarbageCollector(); 
var ControlTree = ASPx.CreateClass(null, {
 constructor: function(controlCollection, container) {
  this.container = container;
  this.domMap = { };
  this.rootNode = this.createNode(null, null);
  this.createControlTree(controlCollection, container);
 },
 forEachControl: function(collapseControls, processFunc) {
  var observer = _aspxGetDomObserver();
  observer.pause(this.container, true);
  var documentScrollInfo;
  if(collapseControls) {
   documentScrollInfo = ASPx.GetOuterScrollPosition(document.body);
   this.collapseControls(this.rootNode);
  }
  var adjustNodes = [], 
   autoHeightNodes = [];
  var requireReAdjust = this.forEachControlCore(this.rootNode, collapseControls, processFunc, adjustNodes, autoHeightNodes);
  if(requireReAdjust)
   this.forEachControlsBackward(adjustNodes, collapseControls, processFunc);
  else {
   for(var i = 0, node; node = autoHeightNodes[i]; i++)
    node.control.AdjustAutoHeight();
  }
  if(collapseControls)
   ASPx.RestoreOuterScrollPosition(documentScrollInfo);
  observer.resume(this.container, true);
 },
 forEachControlCore: function(node, collapseControls, processFunc, adjustNodes, autoHeightNodes) {
  var requireReAdjust = false,
   size, newSize;
  if(node.control) {
   var checkReadjustment = collapseControls && node.control.IsControlCollapsed() && node.control.CanCauseReadjustment();
   if(checkReadjustment)
    size = node.control.GetControlPercentMarkerSize(false, true);
   if(node.control.IsControlCollapsed() && !node.control.IsExpandableByAdjustment())
    node.control.ExpandControl();
   node.control.isInsideHierarchyAdjustment = true;
   processFunc(node.control);
   node.control.isInsideHierarchyAdjustment = false;
   if(checkReadjustment) {
    newSize = node.control.GetControlPercentMarkerSize(false, true);
    requireReAdjust = size.width !== newSize.width;
   }
   if(node.control.sizingConfig.supportAutoHeight)
    autoHeightNodes.push(node);
   node.control.ResetControlPercentMarkerSize();
  }
  for(var childNode, i = 0; childNode = node.children[i]; i++)
   requireReAdjust = this.forEachControlCore(childNode, collapseControls, processFunc, adjustNodes, autoHeightNodes) || requireReAdjust;
  adjustNodes.push(node);
  return requireReAdjust;
 },
 forEachControlsBackward: function(adjustNodes, collapseControls, processFunc) {
  for(var i = 0, node; node = adjustNodes[i]; i++)
   this.forEachControlsBackwardCore(node, collapseControls, processFunc);
 },
 forEachControlsBackwardCore: function(node, collapseControls, processFunc) {
  if(node.control)
   processFunc(node.control);
  if(node.children.length > 1) {
   for(var i = 0, childNode; childNode = node.children[i]; i++) {
    if(childNode.control)
     processFunc(childNode.control);
   }
  }
 },
 collapseControls: function(node) {
  for(var childNode, i = 0; childNode = node.children[i]; i++)
   this.collapseControls(childNode);
  if(node.control && node.control.NeedCollapseControl())
   node.control.CollapseControl();
 },
 createControlTree: function(controlCollection, container) {
  controlCollection.ProcessControlsInContainer(container, function(control) {
   control.RegisterInControlTree(this);
  }.aspxBind(this));
  var fixedNodes = [];
  var fixedNodesChildren = [];
  for(var domElementID in this.domMap) {
   if(!this.domMap.hasOwnProperty(domElementID)) continue;
   var node = this.domMap[domElementID];
   var controlOwner = node.control ? node.control.controlOwner : null;
   if(controlOwner && this.domMap[controlOwner.name])
    continue;
   if(this.isFixedNode(node))
    fixedNodes.push(node);
   else {
    var parentNode = this.findParentNode(domElementID);
    parentNode = parentNode || this.rootNode;
    if(this.isFixedNode(parentNode))
     fixedNodesChildren.push(node);
    else {
     var childNode = node.mainNode || node;
     this.addChildNode(parentNode, childNode);
    }
   }
  }
  for(var i = fixedNodes.length - 1; i >= 0; i--)
   this.insertChildNode(this.rootNode, fixedNodes[i], 0);
  for(var i = fixedNodesChildren.length - 1; i >= 0; i--)
   this.insertChildNode(this.rootNode, fixedNodesChildren[i], 0);
 },
 findParentNode: function(id) {
  var element = document.getElementById(id).parentNode;
  while(element && element.tagName !== "BODY") {
   if(element.id) {
    var parentNode = this.domMap[element.id];
    if(parentNode)
     return parentNode;
   }
   element = element.parentNode;
  }
  return null;
 },
 addChildNode: function(node, childNode) {
  if(!childNode.parentNode) {
   node.children.push(childNode);
   childNode.parentNode = node;
  }
 },
 insertChildNode: function(node, childNode, index) {
  if(!childNode.parentNode) {
   ASPx.Data.ArrayInsert(node.children, childNode, index);
   childNode.parentNode = node;
  }
 },
 addRelatedNode: function(node, relatedNode) {
  this.addChildNode(node, relatedNode);
  relatedNode.mainNode = node;
 },
 isFixedNode: function(node) {
  var control = node.mainNode ? node.mainNode.control : node.control;
  return control && control.HasFixedPosition();
 },
 createNode: function(domElementID, control) {
  var node = {
   control: control,
   children: [],
   parentNode: null,
   mainNode: null
  };
  if(domElementID)
   this.domMap[domElementID] = node;
  return node;
 }
});
function _aspxFunctionIsInCallstack(currentCallee, targetFunction, depthLimit) {
 var candidate = currentCallee;
 var depth = 0;
 while(candidate && depth <= depthLimit) {
  candidate = candidate.caller;
  if(candidate == targetFunction)
   return true;
  depth++;
 }
 return false;
}
ASPx.Evt.AttachEventToElement(window, "load", aspxClassesWindowOnLoad);
function aspxClassesWindowOnLoad(evt){
 ASPx.documentLoaded = true;
 _aspxSweepDuplicatedLinks();
 ResourceManager.SynchronizeResources();
 var externalScriptProcessor = GetExternalScriptProcessor();
 if(externalScriptProcessor)
  externalScriptProcessor.ShowErrorMessages();
 ASPx.AccessibilityUtils.initialize();
 ASPx.GetControlCollection().Initialize();
 _aspxInitializeScripts();
 _aspxInitializeLinks();
 _aspxInitializeFocus();
}
Ident = { };
Ident.IsDate = function(obj) {
 return obj && obj.constructor == Date;
};
Ident.IsRegExp = function(obj) {
 return obj && obj.constructor === RegExp;
};
Ident.IsArray = function(obj) {
 return obj && obj.constructor == Array;
};
Ident.IsASPxClientCollection = function(obj) {
 return obj && obj.isASPxClientCollection;
};
Ident.IsASPxClientControl = function(obj) {
 return obj && obj instanceof ASPxClientControlBase;
};
Ident.IsASPxClientEdit = function(obj) {
 return obj && obj.isASPxClientEdit;
};
Ident.IsFocusableElementRegardlessTabIndex = function (element) {
 var tagName = element.tagName;
 return tagName == "TEXTAREA" || tagName == "INPUT" || tagName == "A" || 
  tagName == "SELECT" || tagName == "IFRAME" || tagName == "OBJECT";
};
Ident.isDialogInvisibleControl = function(control) {
 return !!ASPx.Dialog && ASPx.Dialog.isDialogInvisibleControl(control);
};
Ident.scripts = {};
if(ASPx.IsFunction(window.WebForm_InitCallbackAddField)) {
 (function() {
  var original = window.WebForm_InitCallbackAddField;
  window.WebForm_InitCallbackAddField = function(name, value) {
   if(typeof(name) == "string" && name)
    original.apply(null, arguments);
  };
 })();
}
ASPx.FireDefaultButton = function(evt, buttonID) {
 if(_aspxIsDefaultButtonEvent(evt, buttonID)) {
  var defaultButton = ASPx.GetElementById(buttonID);
  if(defaultButton && defaultButton.click) {
   if(ASPx.IsFocusable(defaultButton))
    defaultButton.focus();
   ASPx.Evt.DoElementClick(defaultButton);
   ASPx.Evt.PreventEventAndBubble(evt);
   return false;
  }
 }
 return true;
}
function _aspxIsDefaultButtonEvent(evt, defaultButtonID) {
 if(evt.keyCode != ASPx.Key.Enter)
  return false;
 var srcElement = ASPx.Evt.GetEventSource(evt);
 if(!srcElement || srcElement.id === defaultButtonID)
  return true;
 var tagName = srcElement.tagName;
 var type = srcElement.type;
 return tagName != "TEXTAREA" && tagName != "BUTTON" && tagName != "A" &&
  (tagName != "INPUT" || type != "checkbox" && type != "radio" && type != "button" && type != "submit" && type != "reset");
}
var PostHandler = ASPx.CreateClass(null, {
 constructor: function() {
  this.Post = new ASPxClientEvent();
  this.PostFinalization = new ASPxClientEvent();
  this.observableForms = [];
  this.dxCallbackTriggers = {};
  this.lastSubmitElementName = null;
  this.beforeOnSubmit = function() { };
  this.ReplaceGlobalPostFunctions();
  this.HandleDxCallbackBeginning();
  this.HandleMSAjaxRequestBeginning();
 },
 Update: function() {
  this.ReplaceFormsSubmit(true);
 },
 ProcessPostRequest: function(ownerID, isCallback, isMSAjaxRequest, isDXCallback) {
  this.cancelPostProcessing = false;
  this.isMSAjaxRequest = isMSAjaxRequest;
  if(this.SkipRaiseOnPost(ownerID, isCallback, isDXCallback))
   return;
  var args = new PostHandlerOnPostEventArgs(ownerID, isCallback, isMSAjaxRequest, isDXCallback);
  this.Post.FireEvent(this, args);
  this.cancelPostProcessing = args.cancel;
  if(!args.cancel)
   this.PostFinalization.FireEvent(this, args);
 },
 SkipRaiseOnPost: function(ownerID, isCallback, isDXCallback) { 
  if(!isCallback)
   return false;
  var dxOwner = isDXCallback && ASPx.GetControlCollection().GetByName(ownerID);
  if(dxOwner) {
   this.dxCallbackTriggers[dxOwner.uniqueID] = true;
   return false;
  }
  if(this.dxCallbackTriggers[ownerID]) {
   this.dxCallbackTriggers[ownerID] = false;
   return true;
  }
  return false;
 },
 ReplaceGlobalPostFunctions: function() {
  if(ASPx.IsFunction(window.__doPostBack))
   this.ReplaceDoPostBack();
  if(ASPx.IsFunction(window.WebForm_DoCallback))
   this.ReplaceDoCallback();
  this.ReplaceFormsSubmit();
 },
 HandleDxCallbackBeginning: function() {
  ASPx.GetControlCollection().BeforeInitCallback.AddHandler(function(s, e) {
   aspxRaisePostHandlerOnPost(e.callbackOwnerID, true, false, true); 
  });
 },
 HandleMSAjaxRequestBeginning: function() {
  if(window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance) {
   var pageRequestManager = Sys.WebForms.PageRequestManager.getInstance();
   if(pageRequestManager != null && Ident.IsArray(pageRequestManager._onSubmitStatements)) {
    pageRequestManager._onSubmitStatements.unshift(function() {
     var postbackSettings = Sys.WebForms.PageRequestManager.getInstance()._postBackSettings;
     var postHandler = aspxGetPostHandler();
     aspxRaisePostHandlerOnPost(postbackSettings.asyncTarget, true, true);
     return !postHandler.cancelPostProcessing;
    });
   }
  }
 },
 ReplaceDoPostBack: function() {
  var original = __doPostBack;
  __doPostBack = function(eventTarget, eventArgument) {
   var postHandler = aspxGetPostHandler();
   aspxRaisePostHandlerOnPost(eventTarget);
   if(postHandler.cancelPostProcessing)
    return;
   ASPxClientControl.postHandlingLocked = true;
   original(eventTarget, eventArgument);
   delete ASPxClientControl.postHandlingLocked;
  };
 },
 ReplaceDoCallback: function() {
  var original = WebForm_DoCallback;
  WebForm_DoCallback = function(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync) {
   var postHandler = aspxGetPostHandler();
   aspxRaisePostHandlerOnPost(eventTarget, true);
   if(postHandler.cancelPostProcessing)
    return;
   return original(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync);
  };
 },
 ReplaceFormsSubmit: function(checkObservableCollection) {
  for(var i = 0; i < document.forms.length; i++) { 
   var form = document.forms[i];
   if(checkObservableCollection && ASPx.Data.ArrayIndexOf(this.observableForms, form) >= 0)
    continue;
   if(form.submit)
    this.ReplaceFormSubmit(form);
   this.ReplaceFormOnSumbit(form);
   this.observableForms.push(form);
  }
 },
 ReplaceFormSubmit: function(form) {
  var originalSubmit = form.submit;
  form.submit = function() {
   var postHandler = aspxGetPostHandler();
   aspxRaisePostHandlerOnPost();
   if(postHandler.cancelPostProcessing)
    return false;
   var callee = arguments.callee;
   this.submit = originalSubmit;
   var submitResult = this.submit();
   this.submit = callee;
   return submitResult;
  };
  form = null;
 },
 ReplaceFormOnSumbit: function(form) {
  var originalSubmit = form.onsubmit;
  form.onsubmit = function() {
   var postHandler = aspxGetPostHandler();
   postHandler.beforeOnSubmit();
   if(postHandler.isMSAjaxRequest)
    postHandler.isMsAjaxRequest = false;
   else
    aspxRaisePostHandlerOnPost(postHandler.GetLastSubmitElementName());
   if(postHandler.cancelPostProcessing)
    return false;
   return ASPx.IsFunction(originalSubmit)
    ? originalSubmit.apply(this, arguments)
    : true;
  };
  form = null;
 },
 SetBeforeOnSubmit: function(action) {
  this.beforeOnSubmit = action;
 },
 SetLastSubmitElementName: function(elementName) {
  this.lastSubmitElementName = elementName;
 },
 GetLastSubmitElementName: function() {
  return this.lastSubmitElementName;
 },
 RemoveDisposedFormsFromCache: function(){
  for(var i = 0; this.observableForms && i < this.observableForms.length; i++){
   var form = this.observableForms[i];
   if(!ASPx.IsExistsElement(form)){
    ASPx.Data.ArrayRemove(this.observableForms, form);
    i--;
   }
  }
 }
});
function aspxRaisePostHandlerOnPost(ownerID, isCallback, isMSAjaxRequest, isDXCallback) {
 if(ASPxClientControl.postHandlingLocked) return;
 var postHandler = aspxGetPostHandler();
 if(postHandler)
  postHandler.ProcessPostRequest(ownerID, isCallback, isMSAjaxRequest, isDXCallback);
}
var aspxPostHandler;
function aspxGetPostHandler() {
 if(!aspxPostHandler)
  aspxPostHandler = new PostHandler();
 return aspxPostHandler;
}
var PostHandlerOnPostEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(ownerID, isCallback, isMSAjaxCallback, isDXCallback){
  this.constructor.prototype.constructor.call(this);
  this.ownerID = ownerID;
  this.isCallback = !!isCallback;
  this.isDXCallback = !!isDXCallback;
  this.isMSAjaxCallback = !!isMSAjaxCallback;
 }
});
var ResourceManager = {
 HandlerStr: "DXR.axd?r=",
 ResourceHashes: {},
 SynchronizeResources: function(method){
  if(!method){
   method = function(name, resource) { 
    this.UpdateInputElements(name, resource); 
   }.aspxBind(this);
  }
  var resources = this.GetResourcesData();
  for(var name in resources)
   method(name, resources[name]);
 },
 GetResourcesData: function(){
  return {
   DXScript: this.GetResourcesElementsString(_aspxGetIncludeScripts(), "src", "DXScript"),
   DXCss: this.GetResourcesElementsString(_aspxGetLinks(), "href", "DXCss")
  };
 },
 GetResourcesElementsString: function(elements, urlAttr, id){
  if(!this.ResourceHashes[id]) 
   this.ResourceHashes[id] = {};
  var hash = this.ResourceHashes[id];
  for(var i = 0; i < elements.length; i++) {
   var resourceUrl = ASPx.Attr.GetAttribute(elements[i], urlAttr);
   if(resourceUrl) {
    var pos = resourceUrl.indexOf(this.HandlerStr);
    if(pos > -1){
     var list = resourceUrl.substr(pos + this.HandlerStr.length);
     var ampPos = list.lastIndexOf("-");
     if(ampPos > -1)
      list = list.substr(0, ampPos);
     var indexes = list.split(",");
     for(var j = 0; j < indexes.length; j++)
      hash[indexes[j]] = indexes[j];
    }
    else
     hash[resourceUrl] = resourceUrl;
   }
  }
  var array = [];
  for(var key in hash) 
   array.push(key);
  return array.join(",");
 },
 UpdateInputElements: function(typeName, list){
  for(var i = 0; i < document.forms.length; i++){
   var inputElement = document.forms[i][typeName];
   if(!inputElement)
    inputElement = this.CreateInputElement(document.forms[i], typeName);
   inputElement.value = list;
  }
 },
 CreateInputElement: function(form, typeName){
  var inputElement = ASPx.CreateHiddenField(typeName, typeName);
  form.appendChild(inputElement);
  return inputElement;
 }
};
ASPx.includeScriptPrefix = "dxis_";
ASPx.startupScriptPrefix = "dxss_";
var includeScriptsCache = {};
var createdIncludeScripts = [];
var appendedScriptsCount = 0;
var callbackOwnerNames = [];
var scriptsRestartHandlers = { };
function _aspxIsKnownIncludeScript(script) {
 return !!includeScriptsCache[script.src];
}
function _aspxCacheIncludeScript(script) {
 includeScriptsCache[script.src] = 1;
}
function _aspxProcessScriptsAndLinks(ownerName, isCallback) {
 if(!ASPx.documentLoaded) return; 
 _aspxProcessScripts(ownerName, isCallback);
 getLinkProcessor().process();
 ASPx.ClearCachedCssRules();
}
function _aspxGetStartupScripts() {
 return _aspxGetScriptsCore(ASPx.startupScriptPrefix);
}
function _aspxGetIncludeScripts() {
 return _aspxGetScriptsCore(ASPx.includeScriptPrefix);
}
function _aspxGetScriptsCore(prefix) {
 var result = [];
 var scripts = document.getElementsByTagName("SCRIPT");
 for(var i = 0; i < scripts.length; i++) {
  if(scripts[i].id.indexOf(prefix) == 0)
   result.push(scripts[i]);
 }
 return result;
}
function _aspxGetLinks() {
 var result = [];
 var links = document.getElementsByTagName("LINK");;
 for(var i = 0; i < links.length; i++) 
  result[i] = links[i];
 return result;
}
function _aspxIsLinksLoaded() {
 var links = _aspxGetLinks();
 for(var i = 0, link; link = links[i]; i++) {
  if(link.readyState && link.readyState.toLowerCase() == "loading")
    return false;
  }
 return true;
}
function _aspxInitializeLinks() {
 var links = _aspxGetLinks();
 for(var i = 0; i < links.length; i++)
  links[i].loaded = true; 
}
function _aspxInitializeScripts() {
 var scripts = _aspxGetIncludeScripts();
 for(var i = 0; i < scripts.length; i++)
  _aspxCacheIncludeScript(scripts[i]);   
 var startupScripts = _aspxGetStartupScripts();
 for(var i = 0; i < startupScripts.length; i++)
  startupScripts[i].executed = true; 
}
function _aspxSweepDuplicatedLinks() {
 var hash = { };
 var links = _aspxGetLinks();
 for(var i = 0; i < links.length; i++) {
  var href = links[i].href;
  if(!href)
   continue;
  if(hash[href]){
   if((ASPx.Browser.IE || !hash[href].loaded) && links[i].loaded) {
    ASPx.RemoveElement(hash[href]);
    hash[href] = links[i];
   }
   else
    ASPx.RemoveElement(links[i]);
  }
  else
   hash[href] = links[i];
 }
}
function _aspxSweepDuplicatedScripts() {
 var hash = { };
 var scripts = _aspxGetIncludeScripts();
 for(var i = 0; i < scripts.length; i++) {
  var src = scripts[i].src;
  if(!src) continue;
  if(hash[src])
   ASPx.RemoveElement(scripts[i]);
  else
   hash[src] = scripts[i];
 }
}
function _aspxProcessScripts(ownerName, isCallback) {
 var scripts = _aspxGetIncludeScripts();
 var previousCreatedScript = null;
 var firstCreatedScript = null;
 for(var i = 0; i < scripts.length; i++) {
  var script = scripts[i];
  if(script.src == "") continue; 
  if(_aspxIsKnownIncludeScript(script))
   continue;
  var createdScript = document.createElement("script");
  createdScript.type = "text/javascript";
  createdScript.src = script.src;
  createdScript.id = script.id;
  function AreScriptsEqual(script1, script2) {
   return script1.src == script2.src;
  }
  if(ASPx.Data.ArrayIndexOf(createdIncludeScripts, createdScript, AreScriptsEqual) >= 0)
   continue;
  createdIncludeScripts.push(createdScript);
  ASPx.RemoveElement(script);
  if(ASPx.Browser.IE && ASPx.Browser.Version < 9) {
   createdScript.onreadystatechange = new Function("ASPx.OnScriptReadyStateChangedCallback(this, " + isCallback + ");");
  } else if(ASPx.Browser.Edge || ASPx.Browser.WebKitFamily || (ASPx.Browser.Firefox && ASPx.Browser.Version >= 4) || ASPx.Browser.IE && ASPx.Browser.Version >= 9) {
   createdScript.onload = new Function("ASPx.OnScriptLoadCallback(this, " + isCallback + ");");
   if(firstCreatedScript == null)
    firstCreatedScript = createdScript;
   createdScript.nextCreatedScript = null;
   if(previousCreatedScript != null)
    previousCreatedScript.nextCreatedScript = createdScript;
   previousCreatedScript = createdScript;
  } else {
   createdScript.onload = new Function("ASPx.OnScriptLoadCallback(this);");
   ASPx.AppendScript(createdScript);
   _aspxCacheIncludeScript(createdScript);
  }
 }
 if(firstCreatedScript != null) {
  ASPx.AppendScript(firstCreatedScript);
  _aspxCacheIncludeScript(firstCreatedScript);
 }
 if(isCallback)
  callbackOwnerNames.push(ownerName);
 if(createdIncludeScripts.length == 0) {
  var newLinks = ASPx.GetNodesByTagName(document.body, "link");
  var needProcessLinks = isCallback && newLinks.length > 0;
  if(needProcessLinks)
   needProcessLinks = getLinkProcessor().addLinks(newLinks);
  if(!needProcessLinks)
   ASPx.FinalizeScriptProcessing(isCallback);
 }
}
ASPx.FinalizeScriptProcessing = function(isCallback) {
 createdIncludeScripts = [];
 appendedScriptsCount = 0;
 var linkProcessor = getLinkProcessor();
 if(linkProcessor.hasLinks())
  _aspxSweepDuplicatedLinks();
 linkProcessor.reset();
 _aspxSweepDuplicatedScripts();
 _aspxRunStartupScripts(isCallback);
 ResourceManager.SynchronizeResources();
}
var startupScriptsRunning = false;
function _aspxRunStartupScripts(isCallback) {
 startupScriptsRunning = true;
 try {
  _aspxRunStartupScriptsCore();
 }
 finally {
  startupScriptsRunning = false;
 }
 if(ASPx.documentLoaded) {
  ASPx.GetControlCollection().InitializeElements(isCallback);
  for(var key in scriptsRestartHandlers)
   scriptsRestartHandlers[key]();
  _aspxRunEndCallbackScript();
 }
}
function _aspxIsStartupScriptsRunning(isCallback) {
 return startupScriptsRunning;
}
function _aspxRunStartupScriptsCore() {
 var scripts = _aspxGetStartupScripts();
 var code;
 for(var i = 0; i < scripts.length; i++){
  if(!scripts[i].executed) {
   code = ASPx.GetScriptCode(scripts[i]);
   eval(code);
   scripts[i].executed = true;
  }
 }
}
function _aspxRunEndCallbackScript() {
 while(callbackOwnerNames.length > 0) {
  var callbackOwnerName = callbackOwnerNames.pop();
  var callbackOwner = ASPx.GetControlCollection().Get(callbackOwnerName);
  if(callbackOwner)
   callbackOwner.DoEndCallback();
 }
}
ASPx.OnScriptReadyStateChangedCallback = function(scriptElement, isCallback) {
 if(scriptElement.readyState == "loaded") {
  _aspxCacheIncludeScript(scriptElement);
  for(var i = 0; i < createdIncludeScripts.length; i++) {
   var script = createdIncludeScripts[i];
   if(_aspxIsKnownIncludeScript(script)) {
    if(!script.executed) {
     script.executed = true;
     ASPx.AppendScript(script);
     appendedScriptsCount++;
    }
   } else
    break;
  }
  if(createdIncludeScripts.length == appendedScriptsCount)
   ASPx.FinalizeScriptProcessing(isCallback);
 }
}
ASPx.OnScriptLoadCallback = function(scriptElement, isCallback) {
 appendedScriptsCount++;
 if(scriptElement.nextCreatedScript) {
  ASPx.AppendScript(scriptElement.nextCreatedScript);
  _aspxCacheIncludeScript(scriptElement.nextCreatedScript);
 }
 if(createdIncludeScripts.length == appendedScriptsCount)
  ASPx.FinalizeScriptProcessing(isCallback);
}
function _aspxAddScriptsRestartHandler(objectName, handler) {
 scriptsRestartHandlers[objectName] = handler;
}
function _aspxMoveLinkElements() {
 var head = ASPx.GetNodesByTagName(document, "head")[0];
 var bodyLinks = ASPx.GetNodesByTagName(document.body, "link");
 if(head && bodyLinks.length > 0){
  var headLinks = ASPx.GetNodesByTagName(head, "link");
  var dxLinkAnchor = head.firstChild;
  for(var i = 0; i < headLinks.length; i++){
   if(headLinks[i].href.indexOf(ResourceManager.HandlerStr) > -1)
    dxLinkAnchor = headLinks[i].nextSibling;
  }
  while(bodyLinks.length > 0) 
   head.insertBefore(bodyLinks[0], dxLinkAnchor);
 }
}
var LinkProcessor = ASPx.CreateClass(null, {
 constructor: function() {
  this.loadedLinkCount = 0;
  this.linkInfos = [];
  this.loadingObservationTimerID = -1;
 },
 process: function() {
  if(this.hasLinks()) {
   if(this.isLinkLoadEventSupported())
    this.processViaLoadEvent();
   else
    this.processViaTimer();
  }
  else
   _aspxSweepDuplicatedLinks();
  _aspxMoveLinkElements();
 },
 addLinks: function(links) {
  var prevLinkCount = this.linkInfos.length;
  for(var i = 0; i < links.length; i++) {
   var link = links[i];
   if(link.loaded || link.rel != "stylesheet" || link.type != "text/css" || link.href.toLowerCase().indexOf("dxr.axd?r=") == -1)
    continue;
   var linkInfo = {
    link: link,
    href: link.href
   };
   this.linkInfos.push(linkInfo);
  }
  return prevLinkCount != this.linkInfos.length;
 },
 hasLinks: function() {
  return this.linkInfos.length > 0;
 },
 reset: function() {
  this.linkInfos = [];
  this.loadedLinkCount = 0;
 },
 processViaLoadEvent: function() {
  for(var i = 0, linkInfo; linkInfo = this.linkInfos[i]; i++) {
   if(ASPx.Browser.IE && ASPx.Browser.Version < 9) {
    var that = this;
    linkInfo.link.onreadystatechange = function() { that.onLinkReadyStateChanged(this); };
   }
   else
    linkInfo.link.onload = this.onLinkLoad.aspxBind(this);
  }
 },
 isLinkLoadEventSupported: function() {
  return !(ASPx.Browser.Chrome && ASPx.Browser.MajorVersion < 19 || ASPx.Browser.Firefox && ASPx.Browser.MajorVersion < 9 ||
   ASPx.Browser.Safari && ASPx.Browser.MajorVersion < 6 || ASPx.Browser.AndroidDefaultBrowser && ASPx.Browser.MajorVersion < 4.4);
 },
 processViaTimer: function() {
  if(this.loadingObservationTimerID == -1)
   this.onLinksLoadingObserve();
 },
 onLinksLoadingObserve: function() {
  if(this.getIsAllLinksLoaded()) {
   this.loadingObservationTimerID = -1;
   this.onAllLinksLoad();
  }
  else
   this.loadingObservationTimerID = window.setTimeout(this.onLinksLoadingObserve.aspxBind(this), 100);
 },
 getIsAllLinksLoaded: function() {
  var styleSheets = document.styleSheets;
  var loadedLinkHrefs = { };
  for(var i = 0; i < styleSheets.length; i++) {
   var styleSheet = styleSheets[i];
   try {
    if(styleSheet.cssRules)
     loadedLinkHrefs[styleSheet.href] = 1;
   }
   catch(ex) { }
  }
  var loadedLinksCount = 0;
  for(var i = 0, linkInfo; linkInfo = this.linkInfos[i]; i++) {
   if(loadedLinkHrefs[linkInfo.href])
    loadedLinksCount++;
  }
  return loadedLinksCount == this.linkInfos.length;
 },
 onAllLinksLoad: function() {
  this.reset();
  _aspxSweepDuplicatedLinks();
  if(createdIncludeScripts.length == 0)
   ASPx.FinalizeScriptProcessing(true);
 },
 onLinkReadyStateChanged: function(linkElement) {
  if(linkElement.readyState == "complete")
   this.onLinkLoadCore(linkElement);
 },
 onLinkLoad: function(evt) {
  var linkElement = ASPx.Evt.GetEventSource(evt);
  this.onLinkLoadCore(linkElement);
 },
 onLinkLoadCore: function(linkElement) {
  if(!this.hasLinkElement(linkElement)) return;
  this.loadedLinkCount++;
  if(!ASPx.Browser.Firefox && this.loadedLinkCount == this.linkInfos.length || 
   ASPx.Browser.Firefox && this.loadedLinkCount == 2 * this.linkInfos.length) {
   this.onAllLinksLoad();
  }
 },
 hasLinkElement: function(linkElement) {
  for(var i = 0, linkInfo; linkInfo = this.linkInfos[i]; i++) {
   if(linkInfo.link == linkElement)
    return true;
  }
  return false;
 }
});
var linkProcessor = null;
function getLinkProcessor() {
 if(linkProcessor == null)
  linkProcessor = new LinkProcessor();
 return linkProcessor;
}
var IFrameHelper = ASPx.CreateClass(null, {
 constructor: function(params) {
  this.params = params || {};
  this.params.src = this.params.src || "";
  this.CreateElements();
 },
 CreateElements: function() {
  var elements = IFrameHelper.Create(this.params);
  this.containerElement = elements.container;
  this.iframeElement = elements.iframe;
  this.AttachOnLoadHandler(this, this.iframeElement);
  this.SetLoading(true);
  if(this.params.onCreate)
   this.params.onCreate(this.containerElement, this.iframeElement);
 },
 AttachOnLoadHandler: function(instance, element) {
  ASPx.Evt.AttachEventToElement(element, "load", function() {
   instance.OnLoad(element);
  });
 },
 OnLoad: function(element) {
  this.SetLoading(false, element);
  if(!element.preventCustomOnLoad && this.params.onLoad)
   this.params.onLoad();
 },
 IsLoading: function(element) {
  element = element || this.iframeElement;
  if(element)
   return element.loading;
  return false;
 },
 SetLoading: function(value, element) {
  element = element || this.iframeElement;
  if(element)
   element.loading = value;
 },
 GetContentUrl: function() {
  return this.params.src;
 },
 SetContentUrl: function(url, preventBrowserCaching) {
  if(url) {
   this.params.src = url;
   if(preventBrowserCaching)
    url = IFrameHelper.AddRandomParamToUrl(url);
   this.SetLoading(true);
   this.iframeElement.src = url;
  }
 },
 RefreshContentUrl: function() {
  if(this.IsLoading())
   return;
  this.SetLoading(true);
  var oldContainerElement = this.containerElement;
  var oldIframeElement = this.iframeElement;
  var postfix = "_del" + Math.floor(Math.random()*100000).toString();
  if(this.params.id)
   oldIframeElement.id = this.params.id + postfix;
  if(this.params.name)
   oldIframeElement.name = this.params.name + postfix;
  ASPx.SetStyles(oldContainerElement, { height: 0 });
  this.CreateElements();
  oldIframeElement.preventCustomOnLoad = true;
  oldIframeElement.src = ASPx.BlankUrl;
  window.setTimeout(function() {
   oldContainerElement.parentNode.removeChild(oldContainerElement);
  }, 10000); 
 }
});
IFrameHelper.Create = function(params) {
 var iframeHtmlStringParts = [ "<iframe frameborder='0'" ];
 if(params) {
  if(params.id)
   iframeHtmlStringParts.push(" id='", params.id, "'");
  if(params.name)
   iframeHtmlStringParts.push(" name='", params.name, "'");
  if(params.title)
   iframeHtmlStringParts.push(" title='", params.title, "'");
  if(params.scrolling)
   iframeHtmlStringParts.push(" scrolling='", params.scrolling, "'");
  if(params.src)
   iframeHtmlStringParts.push(" src='", params.src, "'");
 }
 iframeHtmlStringParts.push("></iframe>");
 var containerElement = ASPx.CreateHtmlElementFromString("<div style='border-width: 0px; padding: 0px; margin: 0px'></div>");
 var iframeElement = ASPx.CreateHtmlElementFromString(iframeHtmlStringParts.join(""));
 containerElement.appendChild(iframeElement);
 return {
  container: containerElement,
  iframe: iframeElement
 };
};
IFrameHelper.AddRandomParamToUrl = function(url) {
 var prefix = url.indexOf("?") > -1
  ? "&"
  : "?";
 var param = prefix + Math.floor(Math.random()*100000).toString();
 var anchorIndex = url.indexOf("#");
 return anchorIndex == -1
  ? url + param
  : url.substr(0, anchorIndex) + param + url.substr(anchorIndex);
};
IFrameHelper.GetWindow = function(name) {
 if(ASPx.Browser.IE)
  return window.frames[name].window;
 else{
  var frameElement = document.getElementById(name);
  return (frameElement != null) ? frameElement.contentWindow : null;
 }
};
IFrameHelper.GetDocument = function(name) {
 var frameElement;
 if(ASPx.Browser.IE) {
  frameElement = window.frames[name];
  return (frameElement != null) ? frameElement.document : null;
 }
 else {
  frameElement = document.getElementById(name);
  return (frameElement != null) ? frameElement.contentDocument : null;
 }
};
IFrameHelper.GetDocumentBody = function(name) {
 var doc = IFrameHelper.GetDocument(name);
 return (doc != null) ? doc.body : null;
};
IFrameHelper.GetDocumentHead = function (name) {
 var doc = IFrameHelper.GetDocument(name);
 return (doc != null) ? doc.head || doc.getElementsByTagName('head')[0] : null;
};
IFrameHelper.GetElement = function(name) {
 if(ASPx.Browser.IE)
  return window.frames[name].window.frameElement;
 else
  return document.getElementById(name);
};
var KbdHelper = ASPx.CreateClass(null, {
 constructor: function(control) {
  this.control = control;
 },
 Init: function() {
  KbdHelper.GlobalInit();
  var elements = this.getFocusableElements();
  for(var i = 0; i < elements.length; i++) {
   var element = elements[i];
   element.tabIndex = Math.max(element.tabIndex, 0);
   var instance = this;
   ASPx.Evt.AttachEventToElement(element, "click", function(e) {
    instance.HandleClick(e);
   });  
   ASPx.Evt.AttachEventToElement(element, "focus", function(e) {    
    if(!instance.CanFocus(e))
     return true;
    KbdHelper.active = instance;
   });
   ASPx.Evt.AttachEventToElement(element, "blur", function () {
    instance.onBlur();
   }); 
  }   
 },
 getFocusableElements: function() {
  return [this.GetFocusableElement()]; 
 },
 GetFocusableElement: function() { return this.control.GetMainElement(); },
 canHandleNoFocusAction: function() { 
  var focusableElements = this.getFocusableElements();
  for(var i = 0; i < focusableElements.length; i++) {
   if(focusableElements[i] === _aspxGetFocusedElement())
    return false;
  }
  return true;
 },
 CanFocus: function(e) {
  var tag = ASPx.Evt.GetEventSource(e).tagName;
  if(tag == "A" || tag == "TEXTAREA" || tag == "INPUT" || tag == "SELECT" || tag == "IFRAME" || tag == "OBJECT")
   return false; 
  return true;
 },
 HandleClick: function(e) {
  if(!this.CanFocus(e))
   return;
  this.Focus();
 },
 Focus: function() {
  try {
   this.GetFocusableElement().focus();   
  } catch(e) {
  }
 },
 onBlur: function(){
  delete KbdHelper.active;
 },
 HandleKeyDown: function(e) { }, 
 HandleKeyPress: function(e) { }, 
 HandleKeyUp: function (e) { },
 HandleNoFocusAction: function(e) { },
 FocusByAccessKey: function () { }
});
KbdHelper.GlobalInit = function() {
 if(KbdHelper.ready)
  return;
 ASPx.Evt.AttachEventToDocument("keydown", KbdHelper.OnKeyDown);
 ASPx.Evt.AttachEventToDocument("keypress", KbdHelper.OnKeyPress);
 ASPx.Evt.AttachEventToDocument("keyup", KbdHelper.OnKeyUp);
 KbdHelper.ready = true; 
};
KbdHelper.swallowKey = false;
KbdHelper.accessKeys = { };
KbdHelper.ProcessKey = function(e, actionName) {
 if(!KbdHelper.active) 
  return;
 if (KbdHelper.active.canHandleNoFocusAction()) {
  KbdHelper.active["HandleNoFocusAction"](e, actionName);
  return;
 }
 var ctl = KbdHelper.active.control;
 if(ctl !== ASPx.GetControlCollection().Get(ctl.name)) {
  delete KbdHelper.active;
  return;
 }
 if(!KbdHelper.swallowKey) 
  KbdHelper.swallowKey = KbdHelper.active[actionName](e);
 if(KbdHelper.swallowKey)
  ASPx.Evt.PreventEvent(e);
};
KbdHelper.OnKeyDown = function(e) {
 KbdHelper.swallowKey = false;
 if(KbdHelper.TryAccessKey(KbdHelper.getKeyName(e)))
  ASPx.Evt.PreventEvent(e);
 else 
  KbdHelper.ProcessKey(e, "HandleKeyDown"); 
};
KbdHelper.OnKeyPress = function(e) { KbdHelper.ProcessKey(e, "HandleKeyPress"); };
KbdHelper.OnKeyUp = function(e) { KbdHelper.ProcessKey(e, "HandleKeyUp"); };
KbdHelper.RegisterAccessKey = function(obj) {
 if(obj.accessKey)
  var key = "CtrlShift" + obj.accessKey;
 else if(obj.keyTipModeShortcut)
  var key = obj.keyTipModeShortcut;
 if(!key) return;
 KbdHelper.accessKeys[key.toLowerCase()] = obj.name;
};
KbdHelper.TryAccessKey = function(code) {
 var key = code.toLowerCase ? code.toLowerCase() : String.fromCharCode(code).toLowerCase();
 var name = KbdHelper.accessKeys[key];
 if(!name) return false;
 var obj = ASPx.GetControlCollection().Get(name);
 return KbdHelper.ClickAccessKey(obj);
};
KbdHelper.ClickAccessKey = function (control) {
 if (!control) return false;
 var el = control.GetMainElement();
 if (!el) return false;
 el.focus();
 setTimeout(function () {
  if (KbdHelper.active && KbdHelper.active.FocusByAccessKey)
   KbdHelper.active.FocusByAccessKey();
 }.aspxBind(this), 100);
 return true;
};
KbdHelper.getKeyName = function(e) {
 var name = "";
 if(e.altKey)
  name += "Alt";
 if(e.ctrlKey)
  name += "Ctrl";
 if(e.shiftKey)
  name += "Shift";
 var keyCode = e.key || e.code || String.fromCharCode(ASPx.Evt.GetKeyCode(e));
 if(keyCode.match(/key/i))
  name += keyCode.replace(/key/i, "");
 else if(keyCode.match(/digit/i))
  name += keyCode.replace(/digit/i, "");
 else if(keyCode.match(/arrow/i))
  name += keyCode.replace(/arrow/i, "");
 else if(keyCode.match(/ins/i))
  name += "Ins"
 else if(keyCode.match(/del/i))
  name += "Del"
 else if(keyCode.match(/back/i))
  name += "Back"
 else if(!keyCode.match(/alt/i) && !keyCode.match(/control/i) && !keyCode.match(/shift/i))
  name += keyCode;
 return name.replace(/^a-zA-Z0-9/, "");
};
AccessKeysHelper = ASPx.CreateClass(KbdHelper, {
 constructor: function (control) {
  this.constructor.prototype.constructor.call(this, control);
  this.accessKeysVisible = false;
  this.activeKey = null;
  this.accessKey = new AccessKey(control.accessKey);
  this.accessKeys = this.accessKey.accessKeys;
  this.charIndex = 0;
  this.onFocusByAccessKey = null;
  this.onClose = null;
  this.manualStopProcessing = false;
  this.isActive = false;
 },
 Init: function (control) {
  KbdHelper.prototype.Init.call(this);
  KbdHelper.RegisterAccessKey(control);   
 },
 Add: function (accessKey) {
  this.accessKey.Add(accessKey);
 },
 HandleKeyDown: function (e) {
  var control = this.control;
  var keyCode = ASPx.Evt.GetKeyCode(e);
  var restoreFocus = false;
  var stopProcessing = this.processKeyDown(keyCode);
  if (stopProcessing.value) {
   this.stopProcessing();
   if(this.onClosedOnEscape && (keyCode == ASPx.Key.Esc || stopProcessing.fireEvent))
    this.onClosedOnEscape();
  }
  return stopProcessing;
 },
 HandleNoFocusAction: function (e, actionName) {
  var keyCode = ASPx.Evt.GetKeyCode(e);
  if (this.onClosedOnEscape && keyCode == ASPx.Key.Esc && actionName == "HandleKeyDown")
   this.onClosedOnEscape();
 },
 Activate: function () {
  KbdHelper.ClickAccessKey(this.control);
 },
 Stop: function() {
  this.stopProcessing();
 },
 stopProcessing: function () {
  this.HideAccessKeys();
  if (KbdHelper.active && this.isActive) {
   this.isActive = false;
   KbdHelper.active.control.GetMainElement().blur();
   delete KbdHelper.active;
  }
 },
 onBlur: function () {
  if (this.manualStopProcessing) {
   this.manualStopProcessing = false;
   return;
  }
  this.HideAccessKeys();
  KbdHelper.prototype.onBlur.call(this);
 },
 processKeyDown: function (keyCode) {
  switch (keyCode) {
   case ASPx.Key.Left:
    this.TryMoveFocusLeft();
    return { value: false };
   case ASPx.Key.Right:
    this.TryMoveFocusRight();
    return { value: false };
   case ASPx.Key.Esc:
    if(this.control.hideAllPopups)
     this.control.hideAllPopups(true, true);
    if(this.activeKey)
     this.activeKey = this.activeKey.Return();
    this.charIndex = 0;
    if (!this.activeKey)
     return { value: true };
    break;
   case ASPx.Key.Enter:
    return { value: true };
   default:
    var char = String.fromCharCode(keyCode).toUpperCase();
    var needToContinue = { value: false };
    if(this.activeKey)
     var keyResult = this.activeKey.TryAccessKey(char, this.charIndex, needToContinue);
    if (needToContinue.value) {
     this.charIndex++;
     return { value: false };;
    }
    this.charIndex = 0;
    if(keyResult !== undefined)
     this.activeKey = keyResult;
    else
     return { value: true, fireEvent: true };
    if (!this.activeKey || !this.activeKey.accessKeys || this.activeKey.accessKeys.length == 0) {
     if (this.activeKey && this.activeKey.manualStopProcessing) {
      this.manualStopProcessing = true;
      break;
     }
     return { value: true, fireEvent: true };
    }
  }
  return { value: false };
 },
 TryMoveFocusLeft: function (modifier) {},
 TryMoveFocusRight: function (modifier) {},
 TryMoveFocusUp: function (modifier) {},
 TryMoveFocusDown: function (modifier) {},
 FocusByAccessKey: function () {
  if (this.onFocusByAccessKey)
   this.onFocusByAccessKey();
  this.HideAccessKeys();
  KbdHelper.prototype.FocusByAccessKey.call(this);
  this.activeKey = this.accessKey;
  this.activeKey.execute();
  this.isActive = true;
 },
 HideAccessKeys: function(){
  this.hideAccessKeys(this.accessKey);
 }, 
 hideAccessKeys: function (accessKey) {
  for (var i = 0, ak; ak = accessKey.accessKeys[i]; i++) {
   this.hideAccessKeys(ak);
  }
  if (accessKey)
   accessKey.hide();
 },
 HandleClick: function(e) {
  KbdHelper.prototype.HandleClick.call(this, e);
  this.stopProcessing();
 }
});
AccessKey = ASPx.CreateClass(null, {
 constructor: function (popupItem, getPopupElement, keyTipElement, key, onlyClick, manualStopProcessing) {
  this.key = key ? key : keyTipElement ? ASPxClientUtils.Trim(ASPx.GetInnerText(keyTipElement)) : null;
  this.popupItem = popupItem;
  this.getPopupElement = getPopupElement;
  this.keyTipElement = keyTipElement;
  this.accessKeys = [];
  this.needShowChilds = true;
  this.parent = null;
  this.onlyClick = onlyClick;
  this.manualStopProcessing = manualStopProcessing;
 },
 Add: function (accessKey) {
  this.accessKeys.push(accessKey);
  accessKey.parent = this;
 },
 TryAccessKey: function (char, index, needToContinue) {
  if (!this.accessKeys || this.accessKeys.length == 0)
   return;
  for (var i = 0, accessKey; accessKey = this.accessKeys[i]; i++) {
   if (accessKey.key[index] == char && accessKey.isVisible()) {
    if (accessKey.key[index + 1]) {
     needToContinue.value = true;
    }
    else {
     accessKey.execute();
     return accessKey;
    }
   } else {
    accessKey.hide();
   }
  }
  for (var i = 0, accessKey; accessKey = this.accessKeys[i]; i++) {
   var key = accessKey.TryAccessKey(char, index, needToContinue);
   if (key)
    return key;
  }
  return;
 },
 isVisible: function(){
  return ASPx.GetElementVisibility(this.keyTipElement);
 },
 Return: function () {
  this.hideChildAccessKeys();
  if (this.parent) {
   this.parent.showAccessKeys(true);
  }  
  return this.parent;
 },
 execute: function () {
  this.hideAll();
  if (this.popupItem && this.popupItem.accessKeyClick && !this.onlyClick)
   this.popupItem.accessKeyClick();
  if (this.getPopupElement && this.onlyClick)
   ASPx.Evt.EmulateMouseClick(this.getPopupElement());
  if (this.accessKeys)
   setTimeout(function () {
    this.showAccessKeys(true);
   }.aspxBind(this), 100);
 },
 showAccessKeys: function (directShow) {
  if (!directShow && !this.needShowChilds)
   return;
  for (var i = 0; i < this.accessKeys.length; i++) {
   var accessKey = this.accessKeys[i];
   if (accessKey) {
    var popupElement = accessKey.getPopupElement ? accessKey.getPopupElement() : null;
    if (popupElement && ASPx.IsElementVisible(popupElement, true)) {
     this.show(accessKey);
    }
    accessKey.showAccessKeys();
   }
  }
 },
 show: function (accessKey) {
  var keyTipElement = accessKey.keyTipElement;
  var popupElement = accessKey.getPopupElement();
  var top = ASPx.GetAbsolutePositionY(popupElement);
  var left = ASPx.GetAbsolutePositionX(popupElement);
  if (accessKey.popupItem.getAccessKeyPosition)
   switch (accessKey.popupItem.getAccessKeyPosition()) {
    case "AboveRight":
     left = left + popupElement.offsetWidth - keyTipElement.offsetWidth / 3;
     top = top - keyTipElement.offsetHeight / 2;
     break;
    case "Right":
     left = left + popupElement.offsetWidth - keyTipElement.offsetWidth / 3;
     top = top + popupElement.offsetHeight / 2 - keyTipElement.offsetHeight / 2;
     break;
    case "BelowRight":
     left = left + popupElement.offsetWidth - keyTipElement.offsetWidth / 3;
     top = top + keyTipElement.offsetHeight / 2;
     break;
    default:
     top = top + popupElement.offsetHeight;
     left = left + popupElement.offsetWidth / 2 - keyTipElement.offsetWidth / 2;
     break;
   }
  else {
   top = top + popupElement.offsetHeight;
   left = left + popupElement.offsetWidth / 2 - keyTipElement.offsetWidth / 2;
  }
  ASPx.SetAbsoluteY(keyTipElement, top);
  ASPx.SetAbsoluteX(keyTipElement, left);
  ASPx.SetElementVisibility(keyTipElement, true); 
 },
 hide: function () {
  if (this.keyTipElement)
   ASPx.SetElementVisibility(this.keyTipElement, false);
 },
 hideChildAccessKeys: function () {
  this.hideAccessKeys(this.accessKeys);
 },
 hideAccessKeys: function (accessKeys) {
  if (accessKeys) {
   for (var i = 0, accessKey; accessKey = accessKeys[i]; i++) {
    if (accessKey.keyTipElement)
     accessKey.hide();
    accessKey.hideChildAccessKeys();
   }
  }
 },
 hideAll: function () {
  this.getRoot(this).hideChildAccessKeys();
 },
 getRoot: function (accessKey) {
  if (!accessKey.parent)
   return accessKey;
  return this.getRoot(accessKey.parent);
 }
});
var focusedElement = null;
function aspxOnElementFocused(evt) {
 evt = ASPx.Evt.GetEvent(evt);
 if(evt && evt.target)
  focusedElement = evt.target;
}
function _aspxInitializeFocus() {
 if(!ASPx.GetActiveElement())
  ASPx.Evt.AttachEventToDocument("focus", aspxOnElementFocused);
}
function _aspxGetFocusedElement() {
 var activeElement = ASPx.GetActiveElement();
 return activeElement ? activeElement : focusedElement;
}
CheckBoxCheckState = {
 Checked : "Checked",
 Unchecked : "Unchecked",
 Indeterminate : "Indeterminate"
};
CheckBoxInputKey = { 
 Checked : "C",
 Unchecked : "U",
 Indeterminate : "I"
};
var CheckableElementStateController = ASPx.CreateClass(null, {
 constructor: function(imageProperties) {
  this.checkBoxStates = [];
  this.imageProperties = imageProperties;
 },
 GetValueByInputKey: function(inputKey) {
  return this.GetFirstValueBySecondValue("Value", "StateInputKey", inputKey);
 },
 GetInputKeyByValue: function(value) {
  return this.GetFirstValueBySecondValue("StateInputKey", "Value", value);
 },
 GetImagePropertiesNumByInputKey: function(value) {
  return this.GetFirstValueBySecondValue("ImagePropertiesNumber", "StateInputKey", value);
 },
 GetNextCheckBoxValue: function(currentValue, allowGrayed) {
  var currentInputKey = this.GetInputKeyByValue(currentValue);
  var nextInputKey = '';
  switch(currentInputKey) {
   case CheckBoxInputKey.Checked:
    nextInputKey = CheckBoxInputKey.Unchecked; break;
   case CheckBoxInputKey.Unchecked:
    nextInputKey = allowGrayed ? CheckBoxInputKey.Indeterminate : CheckBoxInputKey.Checked; break;
   case CheckBoxInputKey.Indeterminate:
    nextInputKey = CheckBoxInputKey.Checked; break;
  }
  return this.GetValueByInputKey(nextInputKey);
 },
 GetCheckStateByInputKey: function(inputKey) {
  switch(inputKey) {
   case CheckBoxInputKey.Checked: 
    return CheckBoxCheckState.Checked;
   case CheckBoxInputKey.Unchecked: 
    return CheckBoxCheckState.Unchecked;
   case CheckBoxInputKey.Indeterminate: 
    return CheckBoxCheckState.Indeterminate;
  }
 },
 GetValueByCheckState: function(checkState) {
  switch(checkState) {
   case CheckBoxCheckState.Checked: 
    return this.GetValueByInputKey(CheckBoxInputKey.Checked);
   case CheckBoxCheckState.Unchecked: 
    return this.GetValueByInputKey(CheckBoxInputKey.Unchecked);
   case CheckBoxCheckState.Indeterminate: 
    return this.GetValueByInputKey(CheckBoxInputKey.Indeterminate);
  }
 },
 GetFirstValueBySecondValue: function(firstValueName, secondValueName, secondValue) {
  return this.GetValueByFunc(firstValueName, 
   function(checkBoxState) { return checkBoxState[secondValueName] === secondValue; });
 },
 GetValueByFunc: function(valueName, func) {
  for(var i = 0; i < this.checkBoxStates.length; i++) {
   if(func(this.checkBoxStates[i]))
    return this.checkBoxStates[i][valueName];
  }  
 },
 AssignElementClassName: function(element, cssClassPropertyKey, disabledCssClassPropertyKey, assignedClassName) {
  var classNames = [ ];
  for(var i = 0; i < this.imageProperties[cssClassPropertyKey].length; i++) {
   classNames.push(this.imageProperties[disabledCssClassPropertyKey][i]);
   classNames.push(this.imageProperties[cssClassPropertyKey][i]);
  }
  var elementClassName = element.className;
  for(var i = 0; i < classNames.length; i++) {
   var className = classNames[i];
   var index = elementClassName.indexOf(className);
   if(index > -1)
    elementClassName = elementClassName.replace((index == 0 ? '' : ' ') + className, "");
  }
  elementClassName += " " + assignedClassName;
  element.className = elementClassName;
 },
 UpdateInternalCheckBoxDecoration: function(mainElement, inputKey, enabled) {
  var imagePropertiesNumber = this.GetImagePropertiesNumByInputKey(inputKey);
  for(var imagePropertyKey in this.imageProperties) {
   var propertyValue = this.imageProperties[imagePropertyKey][imagePropertiesNumber];
   propertyValue = propertyValue || !isNaN(propertyValue) ? propertyValue : "";
   switch(imagePropertyKey) {
    case "0" : mainElement.title = propertyValue; break;
    case "1" : mainElement.style.width = propertyValue + (propertyValue != "" ? "px" : ""); break;
    case "2" : mainElement.style.height = propertyValue + (propertyValue != "" ? "px" : ""); break;
   }
   if(enabled) {
    switch(imagePropertyKey) {
     case "3" : this.SetImageSrc(mainElement, propertyValue); break;
     case "4" : 
      this.AssignElementClassName(mainElement, "4", "8", propertyValue);
      break;
     case "5" : this.SetBackgroundPosition(mainElement, propertyValue, true); break;
     case "6" : this.SetBackgroundPosition(mainElement, propertyValue, false); break;
    }
   } else {
     switch(imagePropertyKey) {
     case "7" : this.SetImageSrc(mainElement, propertyValue); break;
     case "8" : 
      this.AssignElementClassName(mainElement, "4", "8", propertyValue);
      break;
     case "9" : this.SetBackgroundPosition(mainElement, propertyValue, true); break;
     case "10" : this.SetBackgroundPosition(mainElement, propertyValue, false); break;
    }
   }
  }
 },
 SetImageSrc: function(mainElement, src) {
  if(src === ""){
   mainElement.style.backgroundImage = "";
   mainElement.style.backgroundPosition = "";
  }
  else{
   mainElement.style.backgroundImage = "url('" + src + "')";
   this.SetBackgroundPosition(mainElement, 0, true);
   this.SetBackgroundPosition(mainElement, 0, false);
  }
 },
 SetBackgroundPosition: function(element, value, isX) {
  if(value === "") {
   element.style.backgroundPosition = value;
   return;
  }
  if(element.style.backgroundPosition === "")
   element.style.backgroundPosition = isX ? "-" + value.toString() + "px 0px" : "0px -" + value.toString() + "px";
  else {
   var position = element.style.backgroundPosition.split(' ');
   element.style.backgroundPosition = isX ? '-' + value.toString() + "px " + position[1] :  position[0] + " -" + value.toString() + "px";
  }
 },
 AddState: function(value, stateInputKey, imagePropertiesNumber) {
  this.checkBoxStates.push({
   "Value" : value, 
   "StateInputKey" : stateInputKey, 
   "ImagePropertiesNumber" : imagePropertiesNumber
  });
 },
 GetAriaCheckedValue: function(state) {
  switch(state) {
   case ASPx.CheckBoxCheckState.Checked: return "true";
   case ASPx.CheckBoxCheckState.Unchecked: return "false";
   case ASPx.CheckBoxCheckState.Indeterminate: return "mixed";
   default: return "";
  }
 }
});
CheckableElementStateController.Create = function(imageProperties, valueChecked, valueUnchecked, valueGrayed, allowGrayed) {
 var stateController = new CheckableElementStateController(imageProperties);
 stateController.AddState(valueChecked, CheckBoxInputKey.Checked, 0);
 stateController.AddState(valueUnchecked, CheckBoxInputKey.Unchecked, 1);
 if(typeof(valueGrayed) != "undefined")
  stateController.AddState(valueGrayed, CheckBoxInputKey.Indeterminate, allowGrayed ? 2 : 1);
 stateController.allowGrayed = allowGrayed;
 return stateController;
};
var CheckableElementHelper = ASPx.CreateClass(null, {
 InternalCheckBoxInitialize: function(internalCheckBox) {
  this.AttachToMainElement(internalCheckBox);
  this.AttachToInputElement(internalCheckBox);
 },
 AttachToMainElement: function(internalCheckBox) {
  var instance = this;
  if(internalCheckBox.mainElement) {
    ASPx.Evt.AttachEventToElement(internalCheckBox.mainElement, "click",
    function (evt) { 
     instance.InvokeClick(internalCheckBox, evt);
     if(!internalCheckBox.disableCancelBubble)
      return ASPx.Evt.PreventEventAndBubble(evt);
    }
   );
   ASPx.Evt.AttachEventToElement(internalCheckBox.mainElement, "mousedown",
    function (evt) {
     internalCheckBox.Refocus();
    }
   );
   ASPx.Evt.PreventElementDragAndSelect(internalCheckBox.mainElement, true);
  }
 },
 AttachToInputElement: function(internalCheckBox) {
  var instance = this;
  if(internalCheckBox.inputElement && internalCheckBox.mainElement) {
   var checkableElement = internalCheckBox.accessibilityCompliant ? internalCheckBox.mainElement : internalCheckBox.inputElement;
   ASPx.Evt.AttachEventToElement(checkableElement, "focus",
    function (evt) { 
     if(!internalCheckBox.enabled)
      checkableElement.blur();
     else
      internalCheckBox.OnFocus();
    }
   );
   ASPx.Evt.AttachEventToElement(checkableElement, "blur", 
    function (evt) { 
     internalCheckBox.OnLostFocus();
    }
   );
   ASPx.Evt.AttachEventToElement(checkableElement, "keyup",
    function (evt) { 
     if(ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Space)
      instance.InvokeClick(internalCheckBox, evt);
    }
   );
   ASPx.Evt.AttachEventToElement(checkableElement, "keydown",
    function (evt) { 
     if(ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Space)
      return ASPx.Evt.PreventEvent(evt);
    }
   );
  }
 },
 IsKBSInputWrapperExist: function() {
  return ASPx.Browser.Opera || ASPx.Browser.WebKitFamily;
 },
 GetICBMainElementByInput: function(icbInputElement) {
  return this.IsKBSInputWrapperExist() ? icbInputElement.parentNode.parentNode : icbInputElement.parentNode;
 },
 InvokeClick: function(internalCheckBox, evt) {
   if(internalCheckBox.enabled && !internalCheckBox.readOnly) {
   var inputElementValue = internalCheckBox.inputElement.value;
   var focusableElement = internalCheckBox.accessibilityCompliant ? internalCheckBox.mainElement : internalCheckBox.inputElement; 
   focusableElement.focus();
   if(!ASPx.Browser.IE) 
    internalCheckBox.inputElement.value = inputElementValue;
   this.InvokeClickCore(internalCheckBox, evt)
   }
 },
 InvokeClickCore: function(internalCheckBox, evt) {
  internalCheckBox.OnClick(evt);
 }
});
CheckableElementHelper.Instance = new CheckableElementHelper();
var CheckBoxInternal = ASPx.CreateClass(null, {
 constructor: function(inputElement, stateController, allowGrayed, allowGrayedByClick, helper, container, storeValueInInput, key, disableCancelBubble,
  accessibilityCompliant) {
  this.inputElement = inputElement;
  this.mainElement = helper.GetICBMainElementByInput(this.inputElement);
  this.name = (key ? key : this.inputElement.id) + CheckBoxInternal.GetICBMainElementPostfix();
  this.mainElement.id = this.name;
  this.stateController = stateController;
  this.container = container;
  this.allowGrayed = allowGrayed;
  this.allowGrayedByClick = allowGrayedByClick;
  this.autoSwitchEnabled = true;
  this.storeValueInInput = !!storeValueInInput;
  this.storedInputKey = !this.storeValueInInput ? this.inputElement.value : null;
  this.disableCancelBubble = !!disableCancelBubble;
  this.accessibilityCompliant = accessibilityCompliant;
  this.focusDecoration = null;
  this.focused = false;
  this.focusLocked = false;
  this.enabled = !this.mainElement.className.match(/dxWeb_\w+Disabled(\b|_)/);
  this.readOnly = false;
  this.CheckedChanged = new ASPxClientEvent();
  this.Focus = new ASPxClientEvent();
  this.LostFocus = new ASPxClientEvent();
  helper.InternalCheckBoxInitialize(this);
 },
 ChangeInputElementTabIndex: function() {  
  var changeMethod = this.enabled ? ASPx.Attr.RestoreTabIndexAttribute : ASPx.Attr.SaveTabIndexAttributeAndReset;
  changeMethod(this.inputElement);
 },
 CreateFocusDecoration: function(focusedStyle) {
   this.focusDecoration = new EditorStyleDecoration(this);
   this.focusDecoration.AddStyle('F', focusedStyle[0], focusedStyle[1]);
   this.focusDecoration.AddPostfix("");
 },
 UpdateFocusDecoration: function() {
  this.focusDecoration.Update();
 },  
 StoreInputKey: function(inputKey) {
  if(this.storeValueInInput)
   this.inputElement.value = inputKey;
  else
   this.storedInputKey = inputKey;
 },
 GetStoredInputKey: function() {
  if(this.storeValueInInput)
   return this.inputElement.value;
  else
   return this.storedInputKey;
 },
 OnClick: function(e) {
  if(this.autoSwitchEnabled) {
   var currentValue = this.GetValue();
   var value = this.stateController.GetNextCheckBoxValue(currentValue, this.allowGrayedByClick && this.allowGrayed);
   this.SetValue(value);
  }
  this.CheckedChanged.FireEvent(this, e);
 },
 OnFocus: function() {
  if(!this.IsFocusLocked()) {
   this.focused = true;
   this.UpdateFocusDecoration();
   this.Focus.FireEvent(this, null);
  } else
   this.UnlockFocus();
 },
 OnLostFocus: function() {
  if(!this.IsFocusLocked()) {
   this.focused = false;
   this.UpdateFocusDecoration();
   this.LostFocus.FireEvent(this, null);
  }
 },
 Refocus: function() {
  if(this.focused) {
   this.LockFocus();
   this.inputElement.blur();
   if(ASPx.Browser.MacOSMobilePlatform) {
    window.setTimeout(function() {
     ASPx.SetFocus(this.inputElement);
    }, 100);
   } else {
    ASPx.SetFocus(this.inputElement);
   }
  }
 },
 LockFocus: function() {
  this.focusLocked = true;
 },
 UnlockFocus: function() {
  this.focusLocked = false;
 },
 IsFocusLocked: function() {
  if(!!ASPx.Attr.GetAttribute(this.mainElement, ASPx.Attr.GetTabIndexAttributeName()))
   return false;
  return this.focusLocked;
 },
 SetValue: function(value) {
  var currentValue = this.GetValue();
  if(currentValue !== value) {
   var newInputKey = this.stateController.GetInputKeyByValue(value);
   if(newInputKey) {
    this.StoreInputKey(newInputKey);   
    this.stateController.UpdateInternalCheckBoxDecoration(this.mainElement, newInputKey, this.enabled);
   }
  }
  if(this.accessibilityCompliant) {
   var state = this.GetCurrentCheckState();
   var value = this.stateController.GetAriaCheckedValue(state);
   if(this.mainElement.attributes["aria-checked"] !== undefined)
    this.mainElement.setAttribute("aria-checked", value); 
   if(this.mainElement.attributes["aria-selected"] !== undefined)
    this.mainElement.setAttribute("aria-selected", value); 
  }
 },
 GetValue: function() {
  return this.stateController.GetValueByInputKey(this.GetCurrentInputKey());
 },
 GetCurrentCheckState: function() {
  return this.stateController.GetCheckStateByInputKey(this.GetCurrentInputKey());
 },
 GetCurrentInputKey: function() {
  return this.GetStoredInputKey();
 },
 GetChecked: function() {
  return this.GetCurrentInputKey() === CheckBoxInputKey.Checked;
 },
 SetChecked: function(checked) {
  var newValue = this.stateController.GetValueByCheckState(checked ? CheckBoxCheckState.Checked : CheckBoxCheckState.Unchecked);
  this.SetValue(newValue);
 },
 SetEnabled: function(enabled) {
  if(this.enabled != enabled) {
   this.enabled = enabled;
   this.stateController.UpdateInternalCheckBoxDecoration(this.mainElement, this.GetCurrentInputKey(), this.enabled);
   this.ChangeInputElementTabIndex();
  }
 },
 GetEnabled: function() {
  return this.enabled;
 }
});
CheckBoxInternal.GetICBMainElementPostfix = function() {
 return "_D";
};
var CheckBoxInternalCollection = ASPx.CreateClass(CollectionBase, {
 constructor: function(imageProperties, allowGrayed, storeValueInInput, helper, disableCancelBubble, accessibilityCompliant) {
  this.constructor.prototype.constructor.call(this);
  this.stateController = allowGrayed 
   ? CheckableElementStateController.Create(imageProperties, CheckBoxInputKey.Checked, CheckBoxInputKey.Unchecked, CheckBoxInputKey.Indeterminate, true)
   : CheckableElementStateController.Create(imageProperties, CheckBoxInputKey.Checked, CheckBoxInputKey.Unchecked);
  this.helper = helper || CheckableElementHelper.Instance;
  this.storeValueInInput = !!storeValueInInput;
  this.disableCancelBubble = !!disableCancelBubble;
  this.accessibilityCompliant = accessibilityCompliant;
 },
 Add: function(key, inputElement, container) {
  this.Remove(key);
  var checkBox = this.CreateInternalCheckBox(key, inputElement, container);
  CollectionBase.prototype.Add.call(this, key, checkBox);
  return checkBox;
 },
 SetImageProperties: function(imageProperties) {
  this.stateController.imageProperties = imageProperties;
 },
 CreateInternalCheckBox: function(key, inputElement, container) {
  return new CheckBoxInternal(inputElement, this.stateController, this.stateController.allowGrayed, false, this.helper, container, 
   this.storeValueInInput, key, this.disableCancelBubble, this.accessibilityCompliant);
 }
});
var EditorStyleDecoration = ASPx.CreateClass(null, {
 constructor: function(editor) {
  this.editor = editor;
  this.postfixList = [ ];
  this.styles = { };
  this.innerStyles = { };
  this.nullTextClassName = "";
  this.lockUpdate = false;
 },
 GetStyleSheet: function() {
  return ASPx.GetCurrentStyleSheet();
 },
 AddPostfix: function(value, applyClass, applyBorders, applyBackground) {
  this.postfixList.push(value);
 },
 AddStyle: function(key, className, cssText) {
  this.styles[key] = this.CreateRule(className, cssText);
  this.innerStyles[key] = this.CreateRule("", this.FilterInnerCss(cssText));
 },
 CreateRule: function(className, cssText) {
  return ASPx.Str.Trim(className + " " + ASPx.CreateImportantStyleRule(this.GetStyleSheet(), cssText));
 },
 GetElementByPostfix: function(postfix) {
  return ASPx.GetElementById(this.editor.name + postfix);
 },
 LockUpdate: function() {
  this.lockUpdate = true;
 },
 UnlockUpdate: function() {
  this.lockUpdate = false;
 },
 IsUpdateLocked: function() {
  return this.lockUpdate;
 },
 Update: function() {
  if(this.IsUpdateLocked())
   return;
  this.UpdateCore();
 },
 UpdateCore: function() {
  for(var i = 0; i < this.postfixList.length; i++) {
   var postfix = this.postfixList[i];
   var inner = postfix.length > 0;
   var element = this.GetElementByPostfix(postfix);
   if(element) {
    this.ApplyInvalidStyle(element, inner);
    this.ApplyFocusedStyle(element, inner);
    this.ApplyNullTextStyle(element, inner);
   }
  }
 },
 ApplyInvalidStyle: function(element, inner) {
  if(this.HasDecoration("I")) {
   var isValid = this.editor.GetIsValid();
   this.ApplyDecoration("I", element, inner, !isValid);
  }
 },
 ApplyFocusedStyle: function(element, inner) {
  if(this.HasDecoration("F"))
   this.ApplyDecoration("F", element, inner, this.editor.focused);
 },
 ApplyNullTextStyle: function(element, inner) {
  if(!this.HasDecoration("N"))
   return;  
  var apply = !this.editor.focused;
  if(apply) {
   if(this.editor.CanApplyNullTextDecoration) {
    apply = this.editor.CanApplyNullTextDecoration();
   } else {
    var value = this.editor.GetValue();
    apply = apply && (value == null || value === "");
   }
  }
  if(apply)
   ASPx.Attr.ChangeAttribute(element, "spellcheck", "false");
  else
   ASPx.Attr.RestoreAttribute(element, "spellcheck");
  this.ApplyDecoration("N", element, inner, apply);
 },
 HasDecoration: function(key) {
  return !!this.styles[key];
 },
 ApplyNullTextClassName: function(active) {
  var nullTextClassName = this.GetNullTextClassName();
  var editorMainElement = this.editor.GetMainElement();
  if (active)
   ASPx.AddClassNameToElement(editorMainElement, nullTextClassName);
  else
   ASPx.RemoveClassNameFromElement(editorMainElement, nullTextClassName);
 },
 GetNullTextClassName: function () {
  if (!this.nullTextClassName)
   this.InitializeNullTextClassName();
  return this.nullTextClassName;
 },
 InitializeNullTextClassName: function () {
  var nullTextStyle = this.styles["N"];
  if (nullTextStyle) {
   var nullTextStyleClassNames = nullTextStyle.split(" ");
   for (var i = 0; i < nullTextStyleClassNames.length; i++)
    if (nullTextStyleClassNames[i].match("dxeNullText"))
     this.nullTextClassName = nullTextStyleClassNames[i];
  }
 },
 ApplyDecoration: function(key, element, inner, active) {
  var value = inner ? this.innerStyles[key] : this.styles[key];
  ASPx.RemoveClassNameFromElement(element, value);
  if(ASPx.Browser.IE && ASPx.Browser.MajorVersion >= 11)
   var reflow = element.offsetWidth; 
  if(active) {
   ASPx.AddClassNameToElement(element, value);
   if(ASPx.Browser.IE && ASPx.Browser.Version > 10 && element.border != null) { 
    var border = parseInt(element.border) || 0;
    element.border = 1;
    element.border = border;
   }
  }
 },
 FilterInnerCss: function(css) {
  return css.replace(/(border|background-image)[^:]*:[^;]+/gi, "");
 }
});
var TouchUIHelper = {
 isGesture: false,
 isMouseEventFromScrolling: false,
 isNativeScrollingAllowed: true,
 clickSensetivity: 10,
 documentTouchHandlers: {},
 documentEventAttachingAllowed: true,
 msTouchDraggableClassName: "dxMSTouchDraggable",
 touchMouseDownEventName: ASPx.Browser.WebKitTouchUI ? "touchstart" : (ASPx.Browser.Edge && ASPx.Browser.MSTouchUI && window.PointerEvent ? "pointerdown" : "mousedown"),
 touchMouseUpEventName:   ASPx.Browser.WebKitTouchUI ? "touchend"   : (ASPx.Browser.Edge && ASPx.Browser.MSTouchUI && window.PointerEvent ? "pointerup" : "mouseup"),
 touchMouseMoveEventName: ASPx.Browser.WebKitTouchUI ? "touchmove"  : (ASPx.Browser.Edge && ASPx.Browser.MSTouchUI && window.PointerEvent ? "pointermove" : "mousemove"),
 isTouchEvent: function(evt) {
  if(!evt) return false;
  return ASPx.Browser.WebKitTouchUI && ASPx.IsExists(evt.changedTouches); 
 },
 isTouchEventName: function(eventName) {
  return ASPx.Browser.WebKitTouchUI && (eventName.indexOf("touch") > -1 || eventName.indexOf("gesture") > -1);
 },
 getEventX: function(evt) { 
  return ASPx.Browser.IE ? evt.pageX : evt.changedTouches[0].pageX; 
 },
 getEventY: function (evt) { 
  return ASPx.Browser.IE ? evt.pageY :evt.changedTouches[0].pageY; 
 },
 getWebkitMajorVersion: function(){
  if(!this.webkitMajorVersion){
   var regExp = new RegExp("applewebkit/(\\d+)", "i");
   var matches = regExp.exec(ASPx.Browser.UserAgent);
   if(matches && matches.index >= 1)
    this.webkitMajorVersion = matches[1];
  }
  return this.webkitMajorVersion;
 },
 getIsLandscapeOrientation: function(){
  if(ASPx.Browser.MacOSMobilePlatform || ASPx.Browser.AndroidMobilePlatform)
   return Math.abs(window.orientation) == 90;
  return ASPx.GetDocumentClientWidth() > ASPx.GetDocumentClientHeight();
 },
 nativeScrollingSupported: function() {
  var allowedSafariVersion = ASPx.Browser.Version >= 5.1 && ASPx.Browser.Version < 8; 
  var allowedWebKitVersion = this.getWebkitMajorVersion() > 533 && (ASPx.Browser.Chrome || this.getWebkitMajorVersion() < 600);
  return (ASPx.Browser.MacOSMobilePlatform && (allowedSafariVersion || allowedWebKitVersion))
   || (ASPx.Browser.AndroidMobilePlatform && ASPx.Browser.PlaformMajorVersion >= 3) || (ASPx.Browser.MSTouchUI && (!ASPx.Browser.WindowsPhonePlatform || !ASPx.Browser.IE));
 },
 makeScrollableIfRequired: function(element, options) {
  if(ASPx.Browser.WebKitTouchUI && element) {
   var overflow = ASPx.GetCurrentStyle(element).overflow;
   if(element.tagName == "DIV" &&  overflow != "hidden" && overflow != "visible" ){
    return this.MakeScrollable(element);
   }
  }
 },
 preventScrollOnEvent: function(evt){
 },
 handleFastTapIfRequired: function(evt, action, preventCommonClickEvents) {
  if(ASPx.Browser.WebKitTouchUI && evt.type == 'touchstart' && action) {
   this.FastTapHelper.HandleFastTap(evt, action, preventCommonClickEvents);
   return true;
  }
  return false;
 },
 ensureDocumentSizesCorrect: function (){
  return (document.documentElement.clientWidth - document.documentElement.clientHeight) / (screen.width - screen.height) > 0;
 },
 ensureOrientationChanged: function(onOrientationChangedFunction){
  if(ASPxClientUtils.iOSPlatform || this.ensureDocumentSizesCorrect())
   onOrientationChangedFunction();
  else {
   window.setTimeout(function(){
    this.ensureOrientationChanged(onOrientationChangedFunction);
   }.aspxBind(this), 100);
  }
 },
 onEventAttachingToDocument: function(eventName, func){
  if(ASPx.Browser.MacOSMobilePlatform && this.isTouchEventName(eventName)) {
   if(!this.documentTouchHandlers[eventName])
    this.documentTouchHandlers[eventName] = [];
   this.documentTouchHandlers[eventName].push(func);
   return this.documentEventAttachingAllowed;
  }
  return true;
 },
 onEventDettachedFromDocument: function(eventName, func){
  if(ASPx.Browser.MacOSMobilePlatform && this.isTouchEventName(eventName)) {
   var handlers = this.documentTouchHandlers[eventName];
   if(handlers)
    ASPx.Data.ArrayRemove(handlers, func);
  }
 },
 processDocumentTouchEventHandlers: function(proc) {
  var touchEventNames = ["touchstart", "touchend", "touchmove", "gesturestart", "gestureend"];
  for(var i = 0; i < touchEventNames.length; i++) {
   var eventName = touchEventNames[i];
   var handlers = this.documentTouchHandlers[eventName];
   if(handlers) {
    for(var j = 0; j < handlers.length; j++) {
     proc(eventName,handlers[j]);
    }
   }
  }
 },
 removeDocumentTouchEventHandlers: function() {
  if(ASPx.Browser.MacOSMobilePlatform) {
   this.documentEventAttachingAllowed = false;
   this.processDocumentTouchEventHandlers(ASPx.Evt.DetachEventFromDocumentCore);
  }
 },
 restoreDocumentTouchEventHandlers: function () {
  if(ASPx.Browser.MacOSMobilePlatform) {
   this.documentEventAttachingAllowed = true;
   this.processDocumentTouchEventHandlers(ASPx.Evt.AttachEventToDocumentCore);
  }
 },
 IsNativeScrolling: function() {
  return TouchUIHelper.nativeScrollingSupported() && TouchUIHelper.isNativeScrollingAllowed;
 },
 pointerEnabled: !!(window.PointerEvent || window.MSPointerEvent),
 pointerDownEventName: window.PointerEvent ? "pointerdown" : "MSPointerDown",
 pointerUpEventName: window.PointerEvent ? "pointerup" : "MSPointerUp",
 pointerCancelEventName: window.PointerEvent ? "pointercancel" : "MSPointerCancel",
 pointerMoveEventName: window.PointerEvent ? "pointermove" : "MSPointerMove",
 pointerOverEventName: window.PointerEvent ? "pointerover" : "MSPointerOver",
 pointerOutEventName: window.PointerEvent ? "pointerout" : "MSPointerOut",
 pointerType: {
  Touch: (ASPx.Browser.IE && ASPx.Browser.Version == 10) ? 2 : "touch",
  Pen: (ASPx.Browser.IE && ASPx.Browser.Version == 10) ? 3 : "pen",
  Mouse: (ASPx.Browser.IE && ASPx.Browser.Version == 10) ? 4 : "mouse"
 },
 msGestureEnabled: !!(window.PointerEvent || window.MSPointerEvent) && typeof(MSGesture) != "undefined",
 msTouchCreateGesturesWrapper: function(element, onTap){
  if(!TouchUIHelper.msGestureEnabled) 
   return;
  var gesture = new MSGesture();
  gesture.target = element;
  ASPx.Evt.AttachEventToElement(element, TouchUIHelper.pointerDownEventName, function(evt){
   gesture.addPointer(evt.pointerId);
  });
  ASPx.Evt.AttachEventToElement(element, TouchUIHelper.pointerUpEventName, function(evt){
   gesture.stop();
  });
  if(onTap)
   ASPx.Evt.AttachEventToElement(element, "MSGestureTap", onTap);
  return gesture;
 }
};
var CacheHelper = {};
CacheHelper.GetCachedValueCore = function(obj, key, func, cacheObj, fillValueMethod) {
 if(!cacheObj)
  cacheObj = obj;
 if(!cacheObj.cache)
  cacheObj.cache = {};
 if(!key) 
  key = "default";
 fillValueMethod(obj, key, func, cacheObj);
 return cacheObj.cache[key];
};
CacheHelper.GetCachedValue = function(obj, key, func, cacheObj) {
 return CacheHelper.GetCachedValueCore(obj, key, func, cacheObj, 
  function(obj, key, func, cacheObj) {
   if(!ASPx.IsExists(cacheObj.cache[key]))
    cacheObj.cache[key] = func.apply(obj, []);
  });
};
CacheHelper.GetCachedElement = function(obj, key, func, cacheObj) {
 return CacheHelper.GetCachedValueCore(obj, key, func, cacheObj, 
  function(obj, key, func, cacheObj) {
   if(!ASPx.IsValidElement(cacheObj.cache[key]))
    cacheObj.cache[key] = func.apply(obj, []);
  });
};
CacheHelper.GetCachedElements = function(obj, key, func, cacheObj) {
 return CacheHelper.GetCachedValueCore(obj, key, func, cacheObj, 
  function(obj, key, func, cacheObj) {
   if(!ASPx.IsValidElements(cacheObj.cache[key])){
    var elements = func.apply(obj, []);
    if(!Ident.IsArray(elements))
     elements = [elements];
    cacheObj.cache[key] = elements;
   }
  });
};
CacheHelper.GetCachedElementById = function(obj, id, cacheObj) {
 return CacheHelper.GetCachedElement(obj, id, function() { return ASPx.GetElementById(id); }, cacheObj);
};
CacheHelper.GetCachedChildById = function(obj, parent, id, cacheObj) {
 return CacheHelper.GetCachedElement(obj, id, function() { return ASPx.GetChildById(parent, id); }, cacheObj);
};
CacheHelper.DropCachedValue = function(cacheObj, key) {
 cacheObj.cache[key] = null;
};  
CacheHelper.DropCache = function(cacheObj) {
 cacheObj.cache = null;
};  
var DomObserver = ASPx.CreateClass(null, {
 constructor: function() {
  this.items = { };
 },
 subscribe: function(elementID, callbackFunc) {
  var item = this.items[elementID];
  if(item)
   this.unsubscribe(elementID);
  item = {
   elementID: elementID,
   callbackFunc: callbackFunc,
   pauseCount: 0
  };
  this.prepareItem(item);
  this.items[elementID] = item;
 },
 prepareItem: function(item) {
 },
 unsubscribe: function(elementID) {
  this.items[elementID] = null;
 },
 getItemElement: function(item) {
  var element = this.getElementById(item.elementID);
  if(element)
   return element;
  this.unsubscribe(item.elementID);
  return null;
 },
 getElementById: function(elementID) {
  var element = document.getElementById(elementID);
  return element && ASPx.IsValidElement(element) ? element : null;
 },
 pause: function(element, includeSubtree) {
  this.changeItemsState(element, includeSubtree, true);
 },
 resume: function(element, includeSubtree) {
  this.changeItemsState(element, includeSubtree, false);
 },
 forEachItem: function(processFunc, context) {
  context = context || this;
  for(var itemName in this.items) {
   if(!this.items.hasOwnProperty(itemName))
    continue;
   var item = this.items[itemName];
   if(item) {
    var needBreak = processFunc.call(context, item);
    if(needBreak)
     return;
   }
  }
 },
 changeItemsState: function(element, includeSubtree, pause) {
  this.forEachItem(function(item) {
   if(!element)
    this.changeItemState(item, pause);
   else {
    var itemElement = this.getItemElement(item);
    if(itemElement && (element == itemElement || (includeSubtree && ASPx.GetIsParent(element, itemElement)))) {
     this.changeItemState(item, pause);
     if(!includeSubtree)
      return true;
    }
   }
  }.aspxBind(this));
 },
 changeItemState: function(item, pause) {
  if(pause)
   this.pauseItem(item)
  else
   this.resumeItem(item);
 },
 pauseItem: function(item) {
  item.paused = true;
  item.pauseCount++;
 },
 resumeItem: function(item) {
  if(item.pauseCount > 0) {
   if(item.pauseCount == 1)
    item.paused = false;
   item.pauseCount--;
  }
 }
});
DomObserver.IsMutationObserverAvailable = function() {
 return !!window.MutationObserver;
};
var TimerObserver = ASPx.CreateClass(DomObserver, {
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
  this.timerID = -1;
  this.observationTimeout = 300;
 },
 subscribe: function(elementID, callbackFunc) {
  DomObserver.prototype.subscribe.call(this, elementID, callbackFunc);
  if(!this.isActivated())
   this.startObserving();
 },
 isActivated: function() {
  return this.timerID !== -1;
 },
 startObserving: function() {
  if(this.isActivated())
   window.clearTimeout(this.timerID);
  this.timerID = window.setTimeout(this.onTimeout, this.observationTimeout);
 },
 onTimeout: function() {
  var observer = _aspxGetDomObserver();
  observer.doObserve();
  observer.startObserving();
 },
 doObserve: function() {
  if(!ASPx.documentLoaded) return;
  this.forEachItem(function(item) {
   if(!item.paused)
    this.doObserveForItem(item);
  }.aspxBind(this));
 },
 doObserveForItem: function(item) {
  var element = this.getItemElement(item);
  if(element)
   item.callbackFunc.call(this, element);
 }
});
var MutationObserver = ASPx.CreateClass(DomObserver, {
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
  this.callbackTimeout = 10;
 },
 prepareItem: function(item) {
  item.callbackTimerID = -1;
  var target = this.getElementById(item.elementID);
  if(!target)
   return;
  var observerCallbackFunc = function() {
   if(item.callbackTimerID === -1) {
    var timeoutHander = function() {
     item.callbackTimerID = -1;
     item.callbackFunc.call(this, target);
    }.aspxBind(this);
    item.callbackTimerID = window.setTimeout(timeoutHander, this.callbackTimeout);
   }
  }.aspxBind(this);
  var observer = new window.MutationObserver(observerCallbackFunc);
  var config = { attributes: true, childList: true, characterData: true, subtree: true };
  observer.observe(target, config);
  item.observer = observer;
  item.config = config;
 },
 unsubscribe: function(elementID) {
  var item = this.items[elementID];
  if(item) {
   item.observer.disconnect();
   item.observer = null;
  }
  DomObserver.prototype.unsubscribe.call(this, elementID);
 },
 pauseItem: function(item) {
  DomObserver.prototype.pauseItem.call(this, item);
  item.observer.disconnect();
 },
 resumeItem: function(item) {
  DomObserver.prototype.resumeItem.call(this, item);
  if(!item.paused) {
   var target = this.getItemElement(item);
   if(target)
    item.observer.observe(target, item.config);
  }
 }
});
var domObserver = null;
function _aspxGetDomObserver() {
 if(domObserver == null)
  domObserver = DomObserver.IsMutationObserverAvailable() ? new MutationObserver() : new TimerObserver();
 return domObserver;
};
var ControlUpdateWatcher = ASPx.CreateClass(null, {
 constructor: function() {
  this.helpers = { };
  this.clearLockerTimerID = -1;
  this.clearLockerTimerDelay = 15;
  this.postProcessing = false;
  this.init();
 },
 init: function() {
  var postHandler = aspxGetPostHandler();
  postHandler.Post.AddHandler(this.OnPost, this);
 },
 Add: function(helper) {
  this.helpers[helper.GetName()] = helper;
 },
 CanSendCallback: function(dxCallbackOwner, arg) {
  this.LockConfirmOnBeforeWindowUnload();
  var modifiedHelpers = this.FilterModifiedHelpersByDXCallbackOwner(this.GetModifiedHelpers(), dxCallbackOwner, arg);
  if(modifiedHelpers.length === 0) return true;
  var modifiedHelpersInfo = this.GetToConfirmAndToResetLists(modifiedHelpers, dxCallbackOwner.name);
  if(!modifiedHelpersInfo) return true;
  if(modifiedHelpersInfo.toConfirm.length === 0) {
   this.ResetClientChanges(modifiedHelpersInfo.toReset);
   return true;
  }
  var helper = modifiedHelpersInfo.toConfirm[0];
  if(!confirm(helper.GetConfirmUpdateText()))
   return false;
  this.ResetClientChanges(modifiedHelpersInfo.toReset);
  return true;
 },
 OnPost: function(s, e) {
  if(e.isDXCallback) return;
  this.postProcessing = true;
  this.LockConfirmOnBeforeWindowUnload();
  var modifiedHelpersInfo = this.GetModifedHelpersInfo(e);
  if(!modifiedHelpersInfo) return;
  if(modifiedHelpersInfo.toConfirm.length === 0) {
   this.ResetClientChanges(modifiedHelpersInfo.toReset);
   return;
  }
  var helper = modifiedHelpersInfo.toConfirm[0];
  if(!confirm(helper.GetConfirmUpdateText())) {
   e.cancel = true;
   this.finishPostProcessing();
  }
  if(!e.cancel)
   this.ResetClientChanges(modifiedHelpersInfo.toReset);
 },
 finishPostProcessing: function() {
  this.postProcessing = false;
 },
 GetModifedHelpersInfo: function(e) {
  var modifiedHelpers = this.FilterModifiedHelpers(this.GetModifiedHelpers(), e);
  if(modifiedHelpers.length === 0) return;
  return this.GetToConfirmAndToResetLists(modifiedHelpers, e && e.ownerID);
 },
 GetToConfirmAndToResetLists: function(modifiedHelpers, ownerID) {
  var resetList = [ ];
  var confirmList = [ ];
  for(var i = 0; i < modifiedHelpers.length; i++) {
   var helper = modifiedHelpers[i];
   if(!helper.GetConfirmUpdateText()) { 
    resetList.push(helper);
    continue;
   }
   if(helper.CanShowConfirm(ownerID)) { 
    resetList.push(helper);
    confirmList.push(helper);
   }
  }
  return { toConfirm: confirmList, toReset: resetList };
 },
 FilterModifiedHelpers: function(modifiedHelpers, e) {
  if(modifiedHelpers.length === 0)
   return [ ];
  if(this.RequireProcessUpdatePanelCallback(e))
   return this.FilterModifiedHelpersByUpdatePanels(modifiedHelpers);
  if(this.postProcessing)
   return this.FilterModifiedHelpersByPostback(modifiedHelpers);
  return modifiedHelpers;
 },
 FilterModifiedHelpersByDXCallbackOwner: function(modifiedHelpers, dxCallbackOwner, arg) {
  var result = [ ];
  for(var i = 0; i < modifiedHelpers.length; i++) {
   var helper = modifiedHelpers[i];
   if(helper.NeedConfirmOnCallback(dxCallbackOwner, arg))
    result.push(helper);
  }
  return result;
 },
 FilterModifiedHelpersByUpdatePanels: function(modifiedHelpers) {
  var result = [ ];
  var updatePanels = this.GetUpdatePanelsWaitedForUpdate();
  for(var i = 0; i < updatePanels.length; i++) {
   var panelID = updatePanels[i].replace(/\$/g, "_");
   var panel = ASPx.GetElementById(panelID);
   if(!panel) continue;
   for(var j = 0; j < modifiedHelpers.length; j++) {
    var helper = modifiedHelpers[j];
    if(ASPx.GetIsParent(panel, helper.GetControlMainElement()))
     result.push(helper);
   }
  }
  return result;
 },
 FilterModifiedHelpersByPostback: function(modifiedHelpers) {
  var result = [ ];
  for(var i = 0; i < modifiedHelpers.length; i++) {
   var helper = modifiedHelpers[i];
   if(helper.NeedConfirmOnPostback())
    result.push(helper);
  }
  return result;
 },
 RequireProcessUpdatePanelCallback: function(e) {
  var rManager = this.GetMSRequestManager();
  if(rManager && e && e.isMSAjaxCallback)
   return rManager._postBackSettings.async;
  return false;
 },
 GetUpdatePanelsWaitedForUpdate: function() {
  var rManager = this.GetMSRequestManager();
  if(!rManager) return [ ];
  var panelUniqueIDs = rManager._postBackSettings.panelsToUpdate || [ ];
  var panelClientIDs = [ ];
  for(var i = 0; i < panelUniqueIDs.length; i++) {
   var index = ASPx.Data.ArrayIndexOf(rManager._updatePanelIDs, panelUniqueIDs[i]);
   if(index >= 0)
    panelClientIDs.push(rManager._updatePanelClientIDs[index]);
  }
  return panelClientIDs;
 },
 GetMSRequestManager: function() {
  if(window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance)
   return Sys.WebForms.PageRequestManager.getInstance();
  return null;
 },
 GetModifiedHelpers: function() {
  var result = [ ];
  for(var key in this.helpers) { 
   var helper = this.helpers[key];
   if(helper.HasChanges())
    result.push(helper);
  }
  return result;
 },
 ResetClientChanges: function(modifiedHelpers) {
  for(var i = 0; i < modifiedHelpers.length; i++)
   modifiedHelpers[i].ResetClientChanges();
 },
 GetConfirmUpdateMessage: function() {
  if(this.confirmOnWindowUnloadLocked) return;
  var modifiedHelpersInfo = this.GetModifedHelpersInfo();
  if(!modifiedHelpersInfo || modifiedHelpersInfo.toConfirm.length === 0) 
   return;
  var helper = modifiedHelpersInfo.toConfirm[0];
  return helper.GetConfirmUpdateText();
 },
 LockConfirmOnBeforeWindowUnload: function() {
  this.confirmOnWindowUnloadLocked = true;
  this.clearLockerTimerID = ASPx.Timer.ClearTimer(this.clearLockerTimerID);
  this.clearLockerTimerID = window.setTimeout(function() {
   this.confirmOnWindowUnloadLocked = false;
  }.aspxBind(this), this.clearLockerTimerDelay);
 },
 OnWindowBeforeUnload: function(e) {
  var confirmMessage = this.GetConfirmUpdateMessage();
  if(confirmMessage)
   e.returnValue = confirmMessage;
  this.finishPostProcessing();
  return confirmMessage;
 },
 OnWindowUnload: function(e) {
  if(this.confirmOnWindowUnloadLocked) return;
  var modifiedHelpersInfo = this.GetModifedHelpersInfo();
  if(!modifiedHelpersInfo) return;
  this.ResetClientChanges(modifiedHelpersInfo.toReset);
 },
 OnMouseDown: function(e) {
  if(ASPx.Browser.IE)
   this.PreventBeforeUnloadOnLinkClick(e);
 },
 OnFocusIn: function(e) {
  if(ASPx.Browser.IE)
   this.PreventBeforeUnloadOnLinkClick(e);
 },
 PreventBeforeUnloadOnLinkClick: function(e) {
  if(ASPx.GetObjectKeys(this.helpers).length == 0)
   return;
  var link = ASPx.GetParentByTagName(ASPx.Evt.GetEventSource(e), "A");
  if(!link || link.dxgvLinkClickHanlderAssigned)
   return;
  var url = ASPx.Attr.GetAttribute(link, "href");
  if(!url || url.indexOf("javascript:") < 0)
   return;
  ASPx.Evt.AttachEventToElement(link, "click", function(ev) { return ASPx.Evt.PreventEvent(ev); });
  link.dxgvLinkClickHanlderAssigned = true;
 }
});
ControlUpdateWatcher.Instance = null;
ControlUpdateWatcher.getInstance = function () {
 if (!ControlUpdateWatcher.Instance) {
  ControlUpdateWatcher.Instance = new ControlUpdateWatcher();
  ASPx.Evt.AttachEventToElement(window, "beforeunload", function(e) {
   return ControlUpdateWatcher.Instance.OnWindowBeforeUnload(e);
  });
  ASPx.Evt.AttachEventToElement(window, "unload", function(e) {
   ControlUpdateWatcher.Instance.OnWindowUnload(e);
  });
  ASPx.Evt.AttachEventToDocument("mousedown", function(e) {
   ControlUpdateWatcher.Instance.OnMouseDown(e);
  });
  ASPx.Evt.AttachEventToDocument("focusin", function(e) {
   ControlUpdateWatcher.Instance.OnFocusIn(e);
  });
 }
 return ControlUpdateWatcher.Instance;
};
var UpdateWatcherHelper = ASPx.CreateClass(null, {
 constructor: function(owner) {
  this.owner = owner;
  this.ownerWatcher = ControlUpdateWatcher.getInstance();
  this.ownerWatcher.Add(this);
 },
 GetName: function() {
  return this.owner.name;
 },
 GetControlMainElement: function() {
  return this.owner.GetMainElement();
 },
 GetControlParentForm: function(){
  return ASPx.GetParentByTagName(this.GetControlMainElement(), "FORM");
 },
 CanShowConfirm: function(requestOwnerID) {
  return true;
 },
 HasChanges: function() {
  return false;
 },
 GetConfirmUpdateText: function() {
  return "";
 },
 NeedConfirmOnCallback: function(dxCallbackOwner) {
  return true;
 },
 NeedConfirmOnPostback: function() {
  if(ASPx.IsUploadSubmitRequest)
   return !ASPx.IsUploadSubmitRequest(this.GetControlParentForm());
  return true;
 },
 ResetClientChanges: function() {
 },
 ConfirmOnCustomControlEvent: function() {
  var confirmMessage = this.GetConfirmUpdateText();
  if(confirmMessage)
   return confirm(confirmMessage);
  return false;
 }
});
var ControlCallbackHandlersQueue = ASPx.CreateClass(null, {
 constructor: function (owner) {
  this.owner = owner;
  this.handlerInfos = [];
 },
 addCallbackHandler: function(handlerInfo) {
  this.handlerInfos.push(handlerInfo);
 },
 executeCallbacksHandlers: function() {
  for(var i = 0, handlerInfo; handlerInfo = this.handlerInfos[i]; i++)
   handlerInfo.handler.call(this.owner, handlerInfo.result);
  this.handlerInfos = [];
 }
});
var ControlCallbackQueueHelper = ASPx.CreateClass(null, {
 constructor: function (owner) {
  this.owner = owner;
  this.pendingCallbacks = [];
  this.receivedCallbacks = [];
  this.attachEvents();
 },
 showLoadingElements: function () {
  this.owner.ShowLoadingDiv();
  if (this.owner.IsCallbackAnimationEnabled())
   this.owner.StartBeginCallbackAnimation();
  else
   this.owner.ShowLoadingElementsInternal();
 },
 attachEvents: function () {
  this.owner.EndCallback.AddHandler(this.onEndCallback.aspxBind(this));
  this.owner.CallbackError.AddHandler(this.onCallbackError.aspxBind(this));
 },
 detachEvents: function () {
  this.owner.EndCallback.RemoveHandler(this.onEndCallback);
  this.owner.CallbackError.RemoveHandler(this.onCallbackError);
 },
 onCallbackError: function (owner, result) {
  this.sendErrorToChildControl(result);
 },
 ignoreDuplicates: function () {
  return true;
 },
 hasDuplicate: function (arg) {
  for (var i in this.pendingCallbacks) {
   if (this.pendingCallbacks[i].arg == arg && this.pendingCallbacks[i].state != ASPx.callbackState.aborted)
    return true;
  }
  return false;
 },
 getToken: function (halperContext, callbackInfo) {
  return {
   cancel: function () {
    if (callbackInfo.state == ASPx.callbackState.sent) {
     callbackInfo.state = ASPx.callbackState.aborted;
     halperContext.sendNext();
    }
    if (callbackInfo.state == ASPx.callbackState.inTurn)
     ASPx.Data.ArrayRemove(halperContext.pendingCallbacks, callbackInfo);
   },
   callbackId: -1
  }
 },
 sendCallback: function (arg, handlerContext, handler, commandName) {
  if (this.ignoreDuplicates() && this.hasDuplicate(arg))
   return false;
  var handlerContext = handlerContext || this.owner;
  var callbackInfo = {
   arg: arg,
   handlerContext: handlerContext,
   handler: handler || handlerContext.OnCallback,
   state: ASPx.callbackState.inTurn, callbackId: -1
  };
  this.pendingCallbacks.push(callbackInfo);
  if (!this.hasActiveCallback()) {
   callbackInfo.callbackId = this.owner.CreateCallback(arg, commandName);
   callbackInfo.state = ASPx.callbackState.sent;
  }
  return this.getToken(this, callbackInfo);
 },
 hasActiveCallback: function () {
  return this.getCallbacksInfoByState(ASPx.callbackState.sent).length > 0;
 },
 sendNext: function () {
  var nextCallbackInfo = this.getCallbacksInfoByState(ASPx.callbackState.inTurn)[0];
  if (nextCallbackInfo) {
   nextCallbackInfo.callbackId = this.owner.CreateCallback(nextCallbackInfo.arg);
   nextCallbackInfo.state = ASPx.callbackState.sent;
   return nextCallbackInfo.callbackId;
  }
 },
 onEndCallback: function () {
  if (!this.owner.isErrorOnCallback && this.hasPendingCallbacks()) {
   var curCallbackId;
   var curCallbackInfo;
   var handlerContext;
   for (var i in this.receivedCallbacks) {
    curCallbackId = this.receivedCallbacks[i];
    curCallbackInfo = this.getCallbackInfoById(curCallbackId);
    if (curCallbackInfo.state != ASPx.callbackState.aborted) {
     handlerContext = curCallbackInfo.handlerContext;
     if (handlerContext.OnEndCallback)
      handlerContext.OnEndCallback();
     this.sendNext();
    }
    ASPx.Data.ArrayRemove(this.pendingCallbacks, curCallbackInfo);
   }
   ASPx.Data.ArrayClear(this.receivedCallbacks);
  }
 },
 hasPendingCallbacks: function () {
  return this.pendingCallbacks && this.pendingCallbacks.length && this.pendingCallbacks.length > 0;
 },
 processCallback: function (result, callbackId) {
  this.receivedCallbacks.push(callbackId);
  if (this.hasPendingCallbacks()) {
   var callbackInfo = this.getCallbackInfoById(callbackId);
   if (callbackInfo.state != ASPx.callbackState.aborted)
    callbackInfo.handler.call(callbackInfo.handlerContext, result);
  }
 },
 getCallbackInfoById: function (id) {
  for (var i in this.pendingCallbacks) {
   if (this.pendingCallbacks[i].callbackId == id)
    return this.pendingCallbacks[i];
  }
 },
 getCallbacksInfoByState: function (state) {
  var result = [];
  for (var i in this.pendingCallbacks) {
   if (this.pendingCallbacks[i].state == state)
    result.push(this.pendingCallbacks[i]);
  }
  return result;
 },
 sendErrorToChildControl: function (callbackObj) {
  if (!this.hasPendingCallbacks())
   return;
  var callbackInfo = this.getCallbackInfoById(callbackObj.callbackId || 0);
  if (!callbackInfo)
   return;
  var hasChildControlHandler = (callbackInfo.handlerContext != this.owner) && callbackInfo.handlerContext.OnCallbackError;
  if (hasChildControlHandler)
   callbackInfo.handlerContext.OnCallbackError.call(callbackInfo.handlerContext, callbackObj.message, callbackObj.data);
 }
});
var AccessibilityHelperBase = ASPx.CreateClass(null, {
 constructor: function(control) {
  this.control = control;
  this.timerID = -1;
  this.pronounceMessageTimeout = 500;
  this.activeItem = this.getItems()[0];
  this.pronounceIsStarted = false;
 },
 PronounceMessage: function(text, activeItemArgs, inactiveItemArgs, mainElementArgs, ownerMainElement) {   
  this.timerID = ASPx.Timer.ClearTimer(this.timerID);
  this.pronounceIsStarted = true;
  this.timerID = window.setTimeout(function() {
   this.PronounceMessageCore(text, activeItemArgs, inactiveItemArgs, mainElementArgs, ownerMainElement);
  }.aspxBind(this), this.getPronounceTimeout());
 },
 PronounceMessageCore: function(text, activeItemArgs, inactiveItemArgs, mainElementArgs, ownerMainElement) {
  if(!this.getItems())
   return;
  this.toogleItem();
  var mainElement = this.getMainElement();
  var activeItem = this.getItem(true);
  var inactiveItem = this.getItem();
  if(ASPx.Attr.GetAttribute(mainElement, "role") != "application")
   mainElementArgs = this.addArguments(mainElementArgs, { "aria-activedescendant" : activeItem.id });
  var messageAttrObj = {};
  var activeItemRole = ASPx.Attr.GetAttribute(activeItem, "role");
  var attrName = activeItemRole == "combobox" ? "aria-label" : "innerHtml";
  messageAttrObj[attrName] = ASPx.Str.EncodeHtml(text);
  activeItemArgs = this.addArguments(activeItemArgs, messageAttrObj);
  messageAttrObj[attrName] = "";
  inactiveItemArgs = this.addArguments(inactiveItemArgs, messageAttrObj);
  var errorTextElement = null;
  if(this.control.GetErrorCell()) {
   errorTextElement = this.getAriaExplanatoryTextManager().GetErrorTextElement();
   activeItemArgs = this.addArguments(activeItemArgs,   {"aria-invalid"  : !this.control.isValid ? "true" : "" });
   mainElementArgs = this.addArguments(mainElementArgs, { "aria-invalid" : "" });
   inactiveItemArgs = this.addArguments(inactiveItemArgs,  { "aria-invalid" : "" });
  }
  this.changeActivityAttributes(activeItem, activeItemArgs);
  if(errorTextElement) {
   this.getAriaExplanatoryTextManager().SetOrRemoveText([activeItem], errorTextElement, !this.control.isValid, false, true);
   this.getAriaExplanatoryTextManager().SetOrRemoveText([mainElement, inactiveItem], errorTextElement, false, false, false);
  }
  this.changeActivityAttributes(mainElement, mainElementArgs);
  if(!!ownerMainElement && ASPx.Attr.GetAttribute(ownerMainElement, "role") != "application")
   this.changeActivityAttributes(ownerMainElement, { "aria-activedescendant": activeItem.id });
  this.changeActivityAttributes(inactiveItem, inactiveItemArgs);
  this.pronounceIsStarted = false;
 },
 GetActiveElement: function(inputIsMainElement) {
  if(this.pronounceIsStarted) return null;
  var mainElement = inputIsMainElement ? this.control.GetInputElement() : this.getMainElement();
  var activeElementId = ASPx.Attr.GetAttribute(mainElement, 'aria-activedescendant');
  return activeElementId ? ASPx.GetElementById(activeElementId) : mainElement;
 },
 getMainElement: function() {
  if(!ASPx.IsExistsElement(this.mainElement))
   this.mainElement = this.control.GetAccessibilityAssistantElement();
  return this.mainElement;
 },
 getItems: function() {
  if(!ASPx.IsExistsElement(this.items))
   this.items = ASPx.GetChildElementNodes(this.getMainElement());
  return this.items;
 },
 getItem: function(isActive) {
  if(isActive)
   return this.activeItem;
  var items = this.getItems();
  return items[0] === this.activeItem ? items[1] : items[0];
 },
 getAriaExplanatoryTextManager: function() { return this.control.ariaExplanatoryTextManager; },
 getPronounceTimeout: function() { return this.pronounceMessageTimeout; },
 toogleItem: function() {
  this.activeItem = this.getItem();
 },
 addArguments: function(targetArgs, newArgs) {
  if(!targetArgs) targetArgs = { };
  for(var key in newArgs) {
   if(!targetArgs.hasOwnProperty(key))
    targetArgs[key] = newArgs[key];
  }
  return targetArgs;
 },
 changeActivityAttributes: function(element, args) {
  if(!element)
   return;
  for(var key in args) {
   var value = args[key];
   if(key == "innerHtml")
    ASPx.SetInnerHtml(element, value);
   else {
    var action = value !== "" ? ASPx.Attr.SetAttribute : ASPx.Attr.RemoveAttribute;
    action(element, key, value);
   }
  }
 }
});
var AccessibilityPronouncer = ASPx.CreateClass(null, {
 constructor: function() {
  this.pronouncerId = "dxPronouncer";
  this.initialized = false;
  this.focusableMessageElement = null;
  this.messageElement = null;
  this.pronouncers = {
   live: new AccessibilityLivePronouncer(this),
   descendant: new AccessibilityDescendantPronouncer(this)
  }
 },
 Pronounce: function(args, type) {
  this.pronouncers[type].Pronounce(args);
 },
 EnsureInitialize: function() {
  if(!this.initialized)
   this.initialize();
 },
 RemoveState: function() {
  for(var pronouncer in this.pronouncers)
   pronouncer.RemoveState();
 },
 RestoreControlState: function(type, mainElement) {
  this.pronouncers[type].RestoreControlState(mainElement);
 },
 RestoreElementsState: function(type, elements) {
  this.pronouncers[type].RestoreElementsState(elements);
 },
 RestoreElementState: function(type, element) {
  this.pronouncers[type].RestoreElementState(element);
 },
 initialize: function() {
  this.createFocusableMessageElement();
  this.createMessageElement();
  this.prepareFocusableMessageElement();
  this.setAttributesForKeyboardNavigation();
  this.initialized = true;
 },
 createFocusableMessageElement: function() {
  var focusableMessageElement = document.createElement("DIV");
  document.body.appendChild(focusableMessageElement);
  this.focusableMessageElement = focusableMessageElement;   
 },
 prepareFocusableMessageElement: function() {
  this.focusableMessageElement.className = "dxAIFME";
  this.preventPageScrollingOnSpace();
 },
 preventPageScrollingOnSpace: function() {
  ASPx.Evt.AttachEventToElement(this.focusableMessageElement, 'keydown', function (evt) {
   if(ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Space)
    return ASPx.Evt.PreventEventAndBubble(evt);
  });
 }, 
 setAttributesForKeyboardNavigation: function() {
  ASPx.Attr.Aria.SetApplicationRole(this.focusableMessageElement);
  ASPx.Attr.Aria.SetSilence(this.focusableMessageElement);
 },
 createMessageElement: function() {
  var messageElement = document.createElement("DIV");
  messageElement.id = this.pronouncerId;
  ASPx.Attr.SetAttribute(messageElement, "role", "note");
  this.focusableMessageElement.appendChild(messageElement);
  this.messageElement = messageElement;
 },
 getMessage: function(messagePartsArg) {
  var messageParts = messagePartsArg.filter(function(x) { return ASPx.IsExists(x); });
  return messageParts.join(", ");
 }
});
var AccessibilityPronouncerBase = ASPx.CreateClass(null, {
 constructor: function() {
  this.state = { };
 },
 Pronounce: function(args) {
  var messageElement = this.getMessageElement();
  ASPx.Attr.Aria.SetOrRemoveLabel(messageElement);
  ASPx.SetInnerHtml(messageElement, "");
  this.PronounceCore(args);
 },
 PronounceCore: function(args) { },
 SaveElementState: function(element) { 
  if(this.state[element.id])
   return;
  this.state[element.id] = {
   element: element,
   descendant: ASPx.Attr.GetAttribute(element, ASPx.Attr.Aria.descendant)
  }
 },
 RemoveState: function() {
  this.state = { };
 },
 RestoreControlState: function(mainElement) { 
  for(var elementInfo in this.state) {
   var element = this.state[elementInfo].element;
   if(!mainElement || ASPx.GetIsParent(mainElement, element))
    this.RestoreElementState(element);
  }
 },
 RestoreElementsState: function(elements) { 
  for(var i = 0; i < elements.length; i++)
   this.RestoreElementState(elements[i]);
 },
 RestoreElementState: function(element) {
  var elementState = this.state[element.id];
  if(!elementState)
   return;
  var messageElement = this.getMessageElement();
  ASPx.Attr.Aria.SetOrRemoveDescendant(element, elementState.descendant);
  delete this.state[element.id];
 },
 getMessage: function(args) {
  return ASPx.AccessibilityPronouncer.getMessage(args.messageParts);
 },
 getMessageElement: function() {
  return ASPx.AccessibilityPronouncer.messageElement;
 },
 getFocusableMessageElement: function() {
   return ASPx.AccessibilityPronouncer.focusableMessageElement;
 }
});
var AccessibilityLivePronouncer = ASPx.CreateClass(AccessibilityPronouncerBase, {
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
 },
 PronounceCore: function(args) {
  var message = this.getMessage(args);
  var messageElement = this.getMessageElement();
  ASPx.Attr.SetAttribute(this.getFocusableMessageElement(), "aria-live", "assertive");
  ASPx.Attr.Aria.SetAtomic(this.getFocusableMessageElement(), "true");
  ASPx.SetInnerHtml(messageElement, ASPx.Str.EncodeHtml(message));
 }
});
var AccessibilityDescendantPronouncer = ASPx.CreateClass(AccessibilityPronouncerBase, {
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
 },
 PronounceCore: function(args) {
  var message = this.getMessage(args);
  var activeElement = ASPx.GetActiveElement();
  var messageElement = this.getMessageElement();
  this.SaveElementState(activeElement);
  ASPx.Attr.RemoveAttribute(this.getFocusableMessageElement(), "aria-live");
  ASPx.Attr.RemoveAttribute(this.getFocusableMessageElement(), "aria-atomic");
  ASPx.Attr.Aria.SetOrRemoveLabel(messageElement, message);
  ASPx.Attr.Aria.SetOrRemoveDescendant(activeElement, messageElement.id);
 }
});
ASPx.AccessibilityPronouncerType = {
 live: "live",
 descendant: "descendant"
};
ASPx.AccessibilityPronouncer = new AccessibilityPronouncer();
var RestoreFocusHelper = ASPx.CreateClass(null, {
 constructor: function() {
  this.excludedIDs = [ "DXCBtn" ]; 
  this.pronouncerType = ASPx.AccessibilityPronouncerType.live;
  this.callbackQueue = [];
  this.Initialize();
 },
 Initialize: function() {
  var that = this;
  ASPx.Evt.AttachEventToDocumentCore("DOMContentLoaded", function() {
   ASPxClientControl.GetControlCollection().BeginCallback.AddHandler(that.OnBeginCallback, that);
   ASPxClientControl.GetControlCollection().EndCallback.AddHandler(that.OnEndCallback, that);
  });
 },
 OnBeginCallback: function(s, e) {
  var control = e.control;
  if(!control.allowRestoreFocusOnCallbacks())
   return;
  control.cpFocusTreeLine = this.getFocusTreeLine(control);
  var controlHasCallbackTreeLine = this.callbackQueueContainsTreeLine(control);
  this.pushTreeLineInfoIntoCallbackQueue(control);
  if(control.cpFocusTreeLine && !controlHasCallbackTreeLine)
   control.SendMessageToAssistiveTechnology(this.getDefaultCallbackMessage());
 },
 OnEndCallback: function(s, e) {
  var control = e.control;
  if(!control.allowRestoreFocusOnCallbacks())
   return;
  var treeLineInfo = this.shiftTreeLineInfoFromCallbackQueue(control);
  if(treeLineInfo.queueLength == 0) {
   if(!control.cpFocusTreeLine && treeLineInfo.treeLine)
    control.cpFocusTreeLine = treeLineInfo.treeLine;
   var focusElement = this.findFocusElement(control);
   if(!this.handleActivePopupWindow(focusElement))
    ASPx.AccessibilityUtils.SetFocusAccessible(focusElement);
   delete control.cpFocusTreeLine;
  }
 },
 pushTreeLineInfoIntoCallbackQueue: function(control) {
  var controlTreeLine = control.cpFocusTreeLine ? control.cpFocusTreeLine.slice(0) : null;
  if(!this.callbackQueue[control.name])
   this.callbackQueue[control.name] = [];
  this.callbackQueue[control.name].push(controlTreeLine);
 },
 shiftTreeLineInfoFromCallbackQueue: function(control) {
  var treeLineInfo = { queueLength: 0, treeLine: null };
  var treeLines = this.callbackQueue[control.name];
  if(treeLines && treeLines.length > 0) {
   treeLineInfo.treeLine = treeLines.shift();
   var linesCount = treeLines.length;
   treeLineInfo.queueLength = linesCount;
   if(linesCount > 0 && !treeLines[0] && treeLineInfo.treeLine)
    treeLines[0] = treeLineInfo.treeLine.slice(0);
  }
  return treeLineInfo;
 },
 callbackQueueContainsTreeLine: function(control) {
  var treeLines = this.callbackQueue[control.name];
  if(!treeLines || treeLines.length == 0) 
   return false;
  if(treeLines[treeLines.length - 1])
   return true;
  return false;
 },
 getDefaultCallbackMessage: function() {
  return ASPx.AccessibilitySR.DefaultCallbackMessage;
 },
 handleActivePopupWindow: function(focusElement) {
  if(!ASPx.GetPopupControlCollection)
   return false;
  var activePopupWindow = ASPx.GetPopupControlCollection().GetCurrentActiveWindowElement();
  if(activePopupWindow) {
   var popupInfo = ASPx.GetPopupControlCollection().GetPopupWindowFromID(activePopupWindow.id);
   if(popupInfo.popupControl.setFocusOnCallback && !popupInfo.popupControl.accessibleFocusElement) {
    popupInfo.popupControl.accessibleFocusElement = focusElement;
    return true;
   }
  }
  return false;
 },
 getFocusTreeLine: function(control) {
  var element = document.activeElement;
  var mainElement = control.GetMainElement();
  if(!ASPx.GetIsParent(mainElement, element)) {
   var treeInfo = this.findFocusedControlElement(mainElement, element);
   element = treeInfo.focusElement;
   mainElement = treeInfo.rootElement;
  }
  return this.getTreeLineCore(mainElement, element);
 },
 getTreeLineCore: function(mainElement, element) {
  if(!element) return null;
  treeLine = [ ];
  while(element) {
   treeLine.push({ 
    id: element.id,
    tagName: element.tagName,
    index: ASPx.Data.ArrayIndexOf(element.parentNode.childNodes, element)
   });
   if(element === mainElement || element === document.body)
    break;
   element = element.parentNode;
  }
  return treeLine;
 },
 findFocusedControlElement: function(mainElement, activeElement) {
  var element = null;
  var parentElement = mainElement;
  var focusedEditor = ASPx.IsExists(ASPx.GetFocusedEditor) ? ASPx.GetFocusedEditor() : null;
  if(focusedEditor && ASPx.GetIsParent(mainElement, focusedEditor.GetMainElement()))
   element = focusedEditor.GetFocusableInputElement();
  else {
   if(mainElement && activeElement) {
    var mainControl = ASPx.GetClientControlByElementID(mainElement.id);
    var parentControls = ASPx.GetParentClientControls(activeElement.id);
    for(var i = parentControls.length - 1; i > -1; i--) {   
     if(mainControl.name == parentControls[i].name) {
      element = activeElement;
      var rootIndex = i > 0 ? i - 1 : i;
      parentElement = parentControls[rootIndex].GetMainElement();
      if(!parentElement && parentControls[rootIndex].GetCurrentWindowElement)
       parentElement = parentControls[rootIndex].GetCurrentWindowElement();
      break;
     }
    }
   }
  }
  return { focusElement: element, rootElement: parentElement }; 
 },
 findFocusElement: function(control) {
  if(!control.cpFocusTreeLine)
   return;
  var treeLine = control.cpFocusTreeLine.slice(0);
  var focusElementParent = this.findFocusElementParentById(treeLine);
  if(!focusElementParent) 
   return;
  return this.findFocusElementFromDOMTree(treeLine, focusElementParent);
 },
 findFocusElementParentById: function(treeLine) {
  for(var i = 0; i < treeLine.length; i++) {
   var id = treeLine[i].id;
   if(!this.isValidId(id))
    continue;
   var element = document.getElementById(id);
   if(element) {
    treeLine.splice(i, treeLine.length - i);
    treeLine.reverse();
    return element;
   }
  }
  return null;
 },
 findFocusElementFromDOMTree: function(treeLine, focusElementParent) {
  var element = focusElementParent;
  for(var i = 0; i < treeLine.length; i++) {
   var info = treeLine[i];
   if(info.index >= element.childNodes.length) {
    element = element.childNodes.length > 0 ? element.childNodes[element.childNodes.length - 1] : null;
    return this.findNeighbourFocusElement(element, focusElementParent);
   }
   var child = element.childNodes[info.index];
   if(child.tagName !== info.tagName)
    return this.findNeighbourFocusElement(child, focusElementParent);
   element = child;
  }
  return element;
 },
 findNeighbourFocusElement: function(element, focusElementParent) {
  if(!element || !element.parentNode) return null;
  var neighbours = element.parentNode.childNodes;
  var indices = this.calcLeftRightIndices(ASPx.Data.ArrayIndexOf(neighbours, element), neighbours.length);
  for(var i = 0; i < indices.length; i++) {
   var index = indices[i];
   var actionElement = ASPx.FindFirstChildActionElement(neighbours[index]);
   if(actionElement)
    return actionElement;
  }
  if(element === focusElementParent)
   return null;
  return this.findNeighbourFocusElement(element.parentNode, focusElementParent);
 },
 calcLeftRightIndices: function(startIndex, count) {
  var indices = [ ];
  var incSides = [ 0, 0 ];
  var index = startIndex;
  for(var i = 0; i < count; i++) {
   indices.push(index);
   var even = i % 2 === 0;
   var nextIndex = this.calcNextIndex(startIndex, count, incSides, even);
   if(nextIndex < 0)
    nextIndex = this.calcNextIndex(startIndex, count, incSides, !even);
   index = nextIndex;
  }
  return indices;
 },
 calcNextIndex: function(startIndex, count, incSides, even) {
  var sideIndex = even ? 0 : 1;
  var inc = incSides[sideIndex];
  inc += even ? -1 : 1;
  var nextIndex = startIndex + inc;
  if(nextIndex >= 0 && nextIndex < count) {
   incSides[sideIndex] = inc;
   return nextIndex;
  }
  return -1;
 },
 isValidId: function(id) {
  return id && !this.isExcludedId(id);
 },
 isExcludedId: function(id) {
  var result = false;
  for(var i = 0; i < this.excludedIDs.length; i++) {
   if(id.indexOf(this.excludedIDs[i]) > -1) {
    result = true;
    break;
   }
  }
  return result;
 }
});
var EventStorage = ASPx.CreateClass(null, {
 constructor: function() {
  this.bag = { };
 },
 Save: function(e, data, overwrite) {
  var key = this.getEventKey(e);
  if(this.bag.hasOwnProperty(key) && !overwrite)
   return;
  this.bag[key] = data;
  window.setTimeout(function() { delete this.bag[key]; }.aspxBind(this), 100);
 },
 Load: function(e) {
  var key = this.getEventKey(e);
  return this.bag[key];
 },
 getEventKey: function(e) {
  if(ASPx.IsExists(e.timeStamp))
   return e.timeStamp.toString();
  var eventSource = ASPx.Evt.GetEventSource(e);
  var type = e.type.toString();
  return eventSource ? type + "_" + eventSource.uniqueID.toString() : type;
 }
});
ASPx.RestoreFocusHelper = new RestoreFocusHelper();
EventStorage.Instance = null;
EventStorage.getInstance = function() {
 if(!EventStorage.Instance)
  EventStorage.Instance = new EventStorage();
 return EventStorage.Instance;
};
var GetGlobalObject = function(objectName) {
 var fields = objectName.split('.');
 var obj = window[fields[0]];
 for(var i = 1; obj && i < fields.length; i++) {
  obj = obj[fields[i]];
 }
 return obj;
}
var GetExternalScriptProcessor = function() {
 return ASPx.ExternalScriptProcessor ? ASPx.ExternalScriptProcessor.getInstance() : null;
}
var ThemesWithRipple = ['Material'];
var RippleHelper = {
 rippleTargetClassName: "dxRippleTarget",
 rippleTargetExternalClassName: "dxRippleTargetExternal",
 rippleContainerClassName: "dxRippleContainer",
 rippleClassName: "dxRipple",
 touchRadius: -1,
 isMobileExternalRipple: null,
 zoom: 1,
 Init: function() {
  if(this.getIsRippleFunctionalityEnabled()) {
   setTimeout(function() {
    this.calcTouchRadius();
   }.aspxBind(this), 0);
  }
 },
 calcTouchRadius: function() {
  var testBlock = document.createElement("DIV");
  ASPx.SetStyles(testBlock, {
   height: "1in",
   width: "1in",
   left: "-100%",
   top: "-100%",
   position: "absolute"
  });
  document.body.appendChild(testBlock);
  this.touchRadius = (1.8 / 2.54) * Math.max(testBlock.offsetWidth, testBlock.offsetHeight);
  document.body.removeChild(testBlock);
 },
 isRippleFunctionalityEnabled: null,
 checkRippleFunctionality: function() {
  if(ASPx.Browser.Safari && ASPx.Browser.Version <= 5.1)
   return false;
  try {
   if(document.styleSheets) {
    for(var i = 0; i < document.styleSheets.length; i++) {
     var styleSheet = document.styleSheets[i];
     if(styleSheet.cssRules) {
      for(var j = 0; j < styleSheet.cssRules.length; j++)
       for(var k = 0; k < ThemesWithRipple.length; k++)
        if(styleSheet.cssRules[j].cssText.indexOf(ThemesWithRipple[k]) !== -1)
         return true;
     }
    }
   }
  }
  catch(exc) { }
  return false;
 },
 ReInit: function() {
  this.isRippleFunctionalityEnabled = null;
  this.Init();
 },
 onDocumentMouseDown: function(evt) {
  if(RippleHelper.getIsRippleFunctionalityEnabled())
   RippleHelper.processMouseDown(evt);
 },
 getIsRippleFunctionalityEnabled: function() {
  if(!ASPx.IsExists(this.isRippleFunctionalityEnabled))
   this.isRippleFunctionalityEnabled = this.checkRippleFunctionality();
  return this.isRippleFunctionalityEnabled;
 },
   createTargetInfo: function(target) {
  return { 
   x: ASPx.GetAbsoluteX(target),
   y: ASPx.GetAbsoluteY(target),
   width: target.offsetWidth,
   height: target.offsetHeight,
   classNames: ASPx.GetClassNameList(target),
   getTarget: function() { return target; },
   getRect: function() { return {x: this.x, y: this.y, width: this.width, height: this.height }; }
  };
 },
 createEventInfo: function(evt) {
  return { x: this.getEventX(evt), y: this.getEventY(evt) };
 },
 processMouseDown: function(evt) {
  var evtSource = ASPx.Evt.GetEventSource(evt);
  var rippleTarget = this.getRippleTargetElement(evtSource);
  if(this.needToProcessRipple(rippleTarget, evtSource))
   this.processRipple(this.createTargetInfo(rippleTarget), this.createEventInfo(evt));
 },
 getRippleTargetElement: function(evtSource) {
  if(this.hasRippleMarker(evtSource))
   return evtSource;
  if(evtSource.tagName && evtSource.tagName.toLowerCase() == "input" && ASPx.ElementContainsCssClass(evtSource, "dxTI")) {
   var elements = ASPx.GetChildElementNodesByPredicate(evtSource.parentNode.parentNode, function(element) {
    return this.hasRippleMarker(element);
   }.aspxBind(this));
   return elements && elements[0];
  }
  return ASPx.GetParent(evtSource, function(element) {
   return this.hasRippleMarker(element);
  }.aspxBind(this));
 },
 hasRippleMarker: function(element) {
  if(!ASPx.IsExistsElement(element))
   return false;
  var computedStyles = window.getComputedStyle(element, ":before");
  if(ASPx.IsExists(computedStyles)) {
   var content = computedStyles.getPropertyValue("content");
   if(content.indexOf(this.rippleTargetExternalClassName) > -1) {
    ASPx.AddClassNameToElement(element, this.rippleTargetExternalClassName);
    return true;
   }
   return content.indexOf(this.rippleTargetClassName) > -1;
  }
  return false;
 },
 needToProcessRipple: function(rippleTarget, evtSource) {
  return rippleTarget && ASPx.AnimationUtils && !ASPx.GetParentByPartialClassName(rippleTarget, "Disabled") && 
   !ASPx.ElementContainsCssClass(rippleTarget, "dxgvBatchEditCell") && 
   !ASPx.ElementContainsCssClass(rippleTarget, "dxcvEditForm") &&
   !ASPx.GetParentByPartialClassName(evtSource, "dxcvFocusedCell") &&
   !(ASPx.ElementContainsCssClass(rippleTarget, "dxeCalendarDay") && ASPx.Str.Trim(rippleTarget.textContent) == "");
 },
 hasBothOverflow: function(style) {
  return style.overflow == "scroll" || style.overflow == "auto" || style.overflow == "hidden";
 },
 hasOverflowX: function(style) {
  return style.overflowX == "scroll" || style.overflowX == "auto" || style.overflowX == "hidden";
 },
 hasOverflowY: function(style) {
  return style.overflowY == "scroll" || style.overflowY == "auto" || style.overflowY == "hidden";
 },
 getExternalRippleContainerSize: function(targetRect) {
  if(ASPx.Browser.MobileUI) {
   var origTouchRadius = this.getOriginTouchRadius();
   if(origTouchRadius < targetRect.width || origTouchRadius < targetRect.height)
    origTouchRadius = Math.max(targetRect.width, targetRect.height);
   return {x: targetRect.x + (targetRect.width - origTouchRadius) / 2, y: targetRect.y + (targetRect.height - origTouchRadius) / 2, width: origTouchRadius, height: origTouchRadius };
  }
  var result = { x: 0, y: 0, width: 0, height: 0 };
  var diff = targetRect.width - targetRect.height;
  if(diff > 0) {
   result.x = targetRect.x;
   result.y = targetRect.y - diff / 2;
   result.width = targetRect.width;
   result.height = targetRect.width;
  } else {
   result.x = targetRect.x + diff / 2;
   result.y = targetRect.y;
   result.width = targetRect.height;
   result.height = targetRect.height;
  }
  return result;
 },
 getInternalContainerSize: function(targetInfo) {
  var parentWithOverflow = RippleHelper.getParentWithOverflow(targetInfo.getTarget());
  if(!ASPx.IsExists(parentWithOverflow))
   return targetInfo;
  var parentWithOverflowStyle = ASPx.GetCurrentStyle(parentWithOverflow);
  var bothOverflow = this.hasBothOverflow(parentWithOverflowStyle);
  var overflowX = this.hasOverflowX(parentWithOverflowStyle);
  var overflowY = this.hasOverflowY(parentWithOverflowStyle);
  var parentRect = {
   x: ASPx.GetAbsoluteX(parentWithOverflow),
   y: ASPx.GetAbsoluteY(parentWithOverflow),
   width: parentWithOverflow.offsetWidth,
   height: parentWithOverflow.offsetHeight
  };
  return this.getInternalContainerSizeCore(targetInfo, parentRect, bothOverflow, overflowX, overflowY);
 },
 getInternalContainerSizeCore: function(targetRect, parentRect, bothOverflow, overflowX, overflowY) {
  var result = {};
  ASPx.Data.MergeHashTables(result, targetRect);
  if(bothOverflow || overflowX) {
   result.x = targetRect.x < parentRect.x ? parentRect.x : targetRect.x;
   if(targetRect.x + targetRect.width > parentRect.x + parentRect.width)
    result.width = parentRect.x + parentRect.width - targetRect.x;
   if(parentRect.x > targetRect.x)
    result.width -= (parentRect.x - targetRect.x);
  }
  if(bothOverflow || overflowY) {
   result.y = targetRect.y < parentRect.y ? parentRect.y : targetRect.y;
   if(targetRect.y + targetRect.height > parentRect.y + parentRect.height)
    result.height = parentRect.y + parentRect.height - targetRect.y;
   if(parentRect.y > targetRect.y)
    result.height -= (parentRect.y - targetRect.y);
  }
  return result;
 },
 calculateRippleContainerSize: function(targetInfo, isExternalRipple) {
  return isExternalRipple ? this.getExternalRippleContainerSize(targetInfo) : this.getInternalContainerSize(targetInfo);
 },
 getParentWithOverflow: function(rippleTarget) {
  var result = ASPx.GetParent(rippleTarget, function(element) {
   var elementStyle = ASPx.GetCurrentStyle(element);
   return this.hasBothOverflow(elementStyle) || this.hasOverflowX(elementStyle) || this.hasOverflowY(elementStyle);
  }.aspxBind(this));
  return result;
 },
 getDuration: function(targetInfo) {
  return this.IsExternalRipple(targetInfo) || ASPx.Browser.MobileUI ? 650 : 450;
 },
 createRippleTransition: function(container, rippleElement, radius, targetInfo) {
  var rippleSize = 2 * radius;
  var transitionProperties = {
   width: { from: 0, to: rippleSize, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "width", unit: "px" },
   height: { from: 0, to: rippleSize, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "height", unit: "px" },
   marginLeft: { from: 0, to: -rippleSize / 2, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "marginLeft", unit: "px" },
   marginTop: { from: 0, to: -rippleSize / 2, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "marginTop", unit: "px" },
   opacity: { from: 1, to: 0.05, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "opacity", unit: "%" }
  };
  var rippleTransition = ASPx.AnimationUtils.createMultipleAnimationTransition(rippleElement, {
   transition: ASPx.AnimationConstants.Transitions.RIPPLE,
   duration: this.getDuration(targetInfo),
   onComplete: function(element) {
    ASPx.RemoveElement(container);
   }
  });
  rippleTransition.Start(transitionProperties);
 },
 calculateRadius: function(isExternalRipple, posX, posY, containerRect) {
  var radius = -1;
  if(isExternalRipple) {
   if(ASPx.Browser.MobileUI)
    radius = this.getOriginTouchRadius() / 2;
   else
    radius = Math.max(containerRect.height, containerRect.width);
  } else {
   var width1 = posX - containerRect.x;
   var width2 = containerRect.width - width1;
   var height1 = posY - containerRect.y;
   var height2 = containerRect.height - height1;
   var rippleWidth = Math.max(width1, width2);
   var rippleHeight = Math.max(height1, height2);
   radius = Math.sqrt(Math.pow(rippleHeight, 2) + Math.pow(rippleWidth, 2));
  }
  return radius;
 },
 createRippleElement: function(container, rippleCenter) {
  var rippleElement = document.createElement("DIV");
  rippleElement.className = this.rippleClassName;
  container.appendChild(rippleElement);
  ASPxClientUtils.SetAbsoluteX(rippleElement, rippleCenter.x);
  ASPxClientUtils.SetAbsoluteY(rippleElement, rippleCenter.y);
  return rippleElement;
 },
 processRipple: function(targetInfo, eventInfo) {
  this.initRippleProcess();
  var isExternalRipple = this.IsExternalRipple(targetInfo);
  var rippleCenter = this.getRippleCenter(targetInfo.getRect(), eventInfo, isExternalRipple);
  var container = this.createRippleContainer(targetInfo, isExternalRipple);
  var rippleElement = this.createRippleElement(container, rippleCenter);
  var radius = this.calculateRadius(isExternalRipple, rippleCenter.x, rippleCenter.y, this.getElementRect(container));
  this.createRippleTransition(container, rippleElement, radius, targetInfo);
 },
 initRippleProcess: function() {
  this.isMobileExternalRipple = null;
  this.zoom = screen.width / window.innerWidth;
 },
 getRippleCenter: function(targetInfo, eventInfo, isExternalRipple) {
  var posX = 0;
  var posY = 0;
  if(isExternalRipple) {
   posX = targetInfo.x + targetInfo.width / 2;
   posY = targetInfo.y + targetInfo.height / 2;
  } else {
   posX = eventInfo.x;
   posY = eventInfo.y;
  }
  return {x: posX, y: posY};
 },
 createRippleContainer: function(targetInfo, isExternalRipple) {
  var containerParent = targetInfo.getTarget();
  if(!containerParent)
   return;
  var containerTagName = containerParent.tagName == "TR" ? "TD" : "DIV";
  var container = document.createElement(containerTagName);
  container.className = this.rippleContainerClassName;
  if(containerParent.parentNode && containerParent.tagName == "IMG")
   containerParent = containerParent.parentNode;
  containerParent.appendChild(container);
  if(isExternalRipple)
   container.style.borderRadius = "50%";
  var containerRect = this.calculateRippleContainerSize(targetInfo, isExternalRipple);
  this.assignContainerSettings(container, containerRect);
  return container;
 },
 assignContainerSettings: function(container, containerRect) {
  var properties = {
   height: containerRect.height,
   width: containerRect.width,
   left: ASPx.PrepareClientPosForElement(containerRect.x, container, true),
   top: ASPx.PrepareClientPosForElement(containerRect.y, container, false)
  };
  if(ASPx.Browser.MobileUI)
   ASPx.Data.MergeHashTables(properties, {marginTop: 0, marginLeft: 0 });
  ASPx.SetStyles(container, properties, ASPx.Browser.MobileUI);
 },
 IsExternalRipple: function(targetInfo) {
  var hasExternalRippleClassName = ASPx.ElementContainsCssClass(targetInfo.getTarget(), this.rippleTargetExternalClassName);
  if(!ASPx.Browser.MobileUI)
   return hasExternalRippleClassName;
  return hasExternalRippleClassName || this.IsMobileExternalRipple(targetInfo);
 },
 IsMobileExternalRipple: function(targetInfo) {
  if(this.isMobileExternalRipple == null) {
   var originTouchRadius = this.getOriginTouchRadius();
   this.isMobileExternalRipple = ASPx.Browser.MobileUI && targetInfo.width < originTouchRadius && targetInfo.height < originTouchRadius;
  }
  return this.isMobileExternalRipple;
 },
 RemoveRippleContainer: function(element) {
  var childs = ASPx.GetChildNodesByClassName(element, this.rippleContainerClassName);
  var rippleContainer = childs.length > 0 ? childs[0] : null;
  if(rippleContainer != null)
   rippleContainer.parentNode.removeChild(rippleContainer);
 },
 getEventX: function(evt) {
  return ASPxClientUtils.GetEventX(evt);
 },
 getEventY: function(evt) {
  return ASPxClientUtils.GetEventY(evt);
 },
 getOriginTouchRadius: function() {
  return this.touchRadius / this.zoom;
 },
 getElementRect: function(element) {
  return { x: ASPx.GetAbsoluteX(element), y: ASPx.GetAbsoluteY(element), width: element.offsetWidth, height: element.offsetHeight };
 }
}
var AccessibilitySR = {
 AddStringResources: function(stringResourcesObj) {
  if(stringResourcesObj) {
   for(var key in stringResourcesObj)
    this[key] = stringResourcesObj[key];
  }
 }
};
ASPx.CollectionBase = CollectionBase;
ASPx.FunctionIsInCallstack = _aspxFunctionIsInCallstack;
ASPx.RaisePostHandlerOnPost = aspxRaisePostHandlerOnPost;
ASPx.GetPostHandler = aspxGetPostHandler;
ASPx.ProcessScriptsAndLinks = _aspxProcessScriptsAndLinks;
ASPx.InitializeLinks = _aspxInitializeLinks;
ASPx.InitializeScripts = _aspxInitializeScripts;
ASPx.RunStartupScripts = _aspxRunStartupScripts;
ASPx.IsStartupScriptsRunning = _aspxIsStartupScriptsRunning;
ASPx.AddScriptsRestartHandler = _aspxAddScriptsRestartHandler;
ASPx.GetFocusedElement = _aspxGetFocusedElement;
ASPx.GetDomObserver = _aspxGetDomObserver;
ASPx.CacheHelper = CacheHelper;
ASPx.ControlTree = ControlTree;
ASPx.ControlCallbackHandlersQueue = ControlCallbackHandlersQueue;
ASPx.ResourceManager = ResourceManager;
ASPx.UpdateWatcherHelper = UpdateWatcherHelper;
ASPx.EventStorage = EventStorage;
ASPx.GetGlobalObject = GetGlobalObject;
ASPx.GetExternalScriptProcessor = GetExternalScriptProcessor;
ASPx.CheckBoxCheckState = CheckBoxCheckState;
ASPx.CheckBoxInputKey = CheckBoxInputKey;
ASPx.CheckableElementStateController = CheckableElementStateController;
ASPx.CheckableElementHelper = CheckableElementHelper;
ASPx.CheckBoxInternal = CheckBoxInternal;
ASPx.CheckBoxInternalCollection = CheckBoxInternalCollection;
ASPx.ControlCallbackQueueHelper = ControlCallbackQueueHelper;
ASPx.EditorStyleDecoration = EditorStyleDecoration;
ASPx.AccessibilitySR = AccessibilitySR;
ASPx.KbdHelper = KbdHelper;
ASPx.AccessKeysHelper = AccessKeysHelper;
ASPx.AccessKey = AccessKey;
ASPx.IFrameHelper = IFrameHelper;
ASPx.Ident = Ident;
ASPx.TouchUIHelper = TouchUIHelper;
ASPx.ControlUpdateWatcher = ControlUpdateWatcher;
ASPx.AccessibilityHelperBase = AccessibilityHelperBase;
ASPx.RippleHelper = RippleHelper;
ASPx.ThemesWithRipple = ThemesWithRipple;
window.ASPxClientEvent = ASPxClientEvent;
window.ASPxClientEventArgs = ASPxClientEventArgs;
window.ASPxClientCancelEventArgs = ASPxClientCancelEventArgs;
window.ASPxClientProcessingModeEventArgs = ASPxClientProcessingModeEventArgs;
window.ASPxClientProcessingModeCancelEventArgs = ASPxClientProcessingModeCancelEventArgs;
ASPx.Evt.AttachEventToDocument(TouchUIHelper.touchMouseDownEventName, RippleHelper.onDocumentMouseDown);
ASPx.classesScriptParsed = true;
})();

(function () {
var ASPxClientBeginCallbackEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(command){
  this.constructor.prototype.constructor.call(this);
  this.command = command;
 }
});
var ASPxClientGlobalBeginCallbackEventArgs = ASPx.CreateClass(ASPxClientBeginCallbackEventArgs, {
 constructor: function(control, command){
  this.constructor.prototype.constructor.call(this, command);
  this.control = control;
 }
});
var ASPxClientEndCallbackEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
 }
});
var ASPxClientGlobalEndCallbackEventArgs = ASPx.CreateClass(ASPxClientEndCallbackEventArgs, {
 constructor: function(control){
  this.constructor.prototype.constructor.call(this);
  this.control = control;
 }
});
var ASPxClientCustomDataCallbackEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(result) {
  this.constructor.prototype.constructor.call(this);
  this.result = result;
 }
});
var ASPxClientCallbackErrorEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function (message, callbackId) {
  this.constructor.prototype.constructor.call(this);
  this.message = message;
  this.handled = false;
  this.callbackId = callbackId;
 }
});
var ASPxClientGlobalCallbackErrorEventArgs = ASPx.CreateClass(ASPxClientCallbackErrorEventArgs, {
 constructor: function (control, message, callbackId) {
  this.constructor.prototype.constructor.call(this, message, callbackId);
  this.control = control;
 }
});
var ASPxClientValidationCompletedEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function (container, validationGroup, invisibleControlsValidated, isValid, firstInvalidControl, firstVisibleInvalidControl) {
  this.constructor.prototype.constructor.call(this);
  this.container = container;
  this.validationGroup = validationGroup;
  this.invisibleControlsValidated = invisibleControlsValidated;
  this.isValid = isValid;
  this.firstInvalidControl = firstInvalidControl;
  this.firstVisibleInvalidControl = firstVisibleInvalidControl;
 }
});
var ASPxClientControlsInitializedEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(isCallback) {
  this.isCallback = isCallback;
 }
});
var ASPxClientControlBeforePronounceEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(messageParts, control){
  this.constructor.prototype.constructor.call(this);
  this.messageParts = messageParts;
  this.control = control;
 }
});
var BeforeInitCallbackEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(callbackOwnerID){
  this.constructor.prototype.constructor.call(this);
  this.callbackOwnerID = callbackOwnerID;
 }
});
var ASPxClientControlBase = ASPx.CreateClass(null, {
 constructor: function(name){
  this.name = name;
  this.uniqueID = name;   
  this.globalName = name;
  this.stateObject = null;
  this.encodeHtml = true;
  this.enabled = true;
  this.clientEnabled = true;
  this.savedClientEnabled = true;
  this.clientVisible = true;
  this.accessibilityCompliant = false;
  this.autoPostBack = false;
  this.allowMultipleCallbacks = true;
  this.callBack = null;
  this.enableCallbackAnimation = false;
  this.enableSlideCallbackAnimation = false;
  this.slideAnimationDirection = null;
  this.beginCallbackAnimationProcessing = false;
  this.endCallbackAnimationProcessing = false;
  this.savedCallbackResult = null;
  this.savedCallbacks = null;
  this.isCallbackAnimationPrevented = false;
  this.lpDelay = 300;
  this.lpTimer = -1;
  this.requestCount = 0;
  this.enableSwipeGestures = false;
  this.disableSwipeGestures = false;
  this.supportGestures = false;
  this.repeatedGestureValue = 0;
  this.repeatedGestureCount = 0;
  this.isInitialized = false;
  this.initialFocused = false;
  this.leadingAfterInitCall = ASPxClientControl.LeadingAfterInitCallConsts.None; 
  this.serverEvents = [];
  this.loadingPanelElement = null;
  this.loadingDivElement = null;  
  this.hasPhantomLoadingElements = false;
  this.mainElement = null;
  this.touchUIMouseScroller = null;
  this.hiddenFields = { };
  this.callbackHandlersQueue = new ASPx.ControlCallbackHandlersQueue(this);
  this.Init = new ASPxClientEvent();
  this.BeginCallback = new ASPxClientEvent();
  this.EndCallback = new ASPxClientEvent();
  this.EndCallbackAnimationStart = new ASPxClientEvent();
  this.CallbackError = new ASPxClientEvent();
  this.CustomDataCallback = new ASPxClientEvent();
  this.BeforePronounce = new ASPxClientEvent();
  aspxGetControlCollection().Add(this);
 },
 Initialize: function() {
  if(this.callBack != null)
   this.InitializeCallBackData();
  if (this.useCallbackQueue())
   this.callbackQueueHelper = new ASPx.ControlCallbackQueueHelper(this);
  ASPx.AccessibilityUtils.createAccessibleBackgrounds(this);
  if(this.accessibilityCompliant)
   ASPx.AccessibilityPronouncer.EnsureInitialize();
 },
 InlineInitialize: function() {
  this.savedClientEnabled = this.clientEnabled;
 },
 InitializeGestures: function() {
  if(this.isSwipeGesturesEnabled() && this.supportGestures) {
   ASPx.GesturesHelper.AddSwipeGestureHandler(this.name, 
    function() { return this.GetCallbackAnimationElement(); }.aspxBind(this), 
    function(evt) { return this.CanHandleGestureCore(evt); }.aspxBind(this), 
    function(value) { return this.AllowStartGesture(); }.aspxBind(this),
    function(value) { return this.StartGesture(); }.aspxBind(this),
    function(value) { return this.AllowExecuteGesture(value); }.aspxBind(this),
    function(value) { this.ExecuteGesture(value); }.aspxBind(this),
    function(value) { this.CancelGesture(value); }.aspxBind(this),
    this.GetDefaultanimationEngineType()
   );
   if(ASPx.Browser.MSTouchUI)
    this.touchUIMouseScroller = ASPx.MouseScroller.Create(
     function() { return this.GetCallbackAnimationElement(); }.aspxBind(this),
     function() { return null; },
     function() { return this.GetCallbackAnimationElement(); }.aspxBind(this),
     function(element) { return this.NeedPreventTouchUIMouseScrolling(element); }.aspxBind(this),
     true
    );
  }
 },
 isSwipeGesturesEnabled: function() {
  return !this.disableSwipeGestures && (this.enableSwipeGestures || ASPx.Browser.TouchUI);
 },
 isSlideCallbackAnimationEnabled: function() {
  return this.enableSlideCallbackAnimation || this.isSwipeGesturesEnabled(); 
 },
 InitGlobalVariable: function(varName){
  if(!window) return;
  this.globalName = varName;
  window[varName] = this;
 },
 SetProperties: function(properties, obj){
  if(!obj) obj = this;
  for(var name in properties){
   if(properties.hasOwnProperty(name))
    obj[name] = properties[name];
  }
 },
 SetEvents: function(events, obj){
  if(!obj) obj = this;
  for(var name in events){
   if(events.hasOwnProperty(name) && obj[name] && obj[name].AddHandler)
    obj[name].AddHandler(events[name]);
  }
 },
 InitializeProperties: function(properties){
 },
 useCallbackQueue: function(){
  return false;
 },
 NeedPreventTouchUIMouseScrolling: function(element) {
  return false;
 },
 InitailizeFocus: function() {
  if(this.initialFocused && this.IsVisible())
   this.Focus();
 },
 AfterCreate: function() { 
  this.InlineInitialize();
  this.InitializeGestures();
 },
 AfterInitialize: function() {
  this.initializeAriaDescriptor();
  this.InitailizeFocus();
  this.isInitialized = true;
  this.RaiseInit();
  if(this.savedCallbacks) {
   for(var i = 0; i < this.savedCallbacks.length; i++) 
    this.CreateCallbackInternal(this.savedCallbacks[i].arg, this.savedCallbacks[i].command, 
     false, this.savedCallbacks[i].callbackInfo);
   this.savedCallbacks = null;
  }
 },
 InitializeCallBackData: function() {
 },
 IsDOMDisposed: function() { 
  return !ASPx.IsExistsElement(this.GetMainElement());
 },
 initializeAriaDescriptor: function() {
  if(this.ariaDescription) {
   var descriptionObject = ASPx.Json.Eval(this.ariaDescription)
   if(descriptionObject) {
    this.ariaDescriptor = new AriaDescriptor(this, descriptionObject);
    this.applyAccessibilityAttributes(this.ariaDescriptor); 
   }
  }
 },
 applyAccessibilityAttributes: function() { },
 setAriaDescription: function(selector, argsList) {
  if(this.ariaDescriptor)
   this.ariaDescriptor.setDescription(selector, argsList || [[]]);
 },
 allowRestoreFocusOnCallbacks: function(){
  return this.accessibilityCompliant;
 },
 HtmlEncode: function(text) {
  return this.encodeHtml ? ASPx.Str.EncodeHtml(text) : text;
 },
 IsServerEventAssigned: function(eventName){
  return ASPx.Data.ArrayIndexOf(this.serverEvents, eventName) >= 0;
 },
 OnPost: function(args){
  this.UpdateStateObject();
  if(this.stateObject != null) 
   this.UpdateStateHiddenField();
 },
 OnPostFinalization: function(args){
 },
 UpdateStateObject: function(){
 },
 UpdateStateObjectWithObject: function(obj){
  if(!obj) return;
  if(!this.stateObject)
   this.stateObject = { };
  for(var key in obj)
   this.stateObject[key] = obj[key];
 },
 UpdateStateHiddenField: function(){
  var stateHiddenField = this.GetStateHiddenField()
  if(stateHiddenField) {
   var stateObjectStr = ASPx.Json.ToJson(this.stateObject);
   stateHiddenField.value = ASPx.Str.EncodeHtml(stateObjectStr);
  }
 },
 GetStateHiddenField: function() {
  return this.GetHiddenField(this.GetStateHiddenFieldName(), this.GetStateHiddenFieldID(), 
   this.GetStateHiddenFieldParent(), this.GetStateHiddenFieldOrigin());
 },
 GetStateHiddenFieldName: function() {
  return this.uniqueID;
 },
 GetStateHiddenFieldID: function() {
  return this.name + "_State";
 },
 GetStateHiddenFieldOrigin: function() {
  return this.GetMainElement();
 },
 GetStateHiddenFieldParent: function() {
  var element = this.GetStateHiddenFieldOrigin();
  return element ? element.parentNode : null;
 },
 GetHiddenField: function(name, id, parent, beforeElement) {
  var hiddenField = this.hiddenFields[id];
  if(!hiddenField || !ASPx.IsValidElement(hiddenField)) {
   if(parent) {
    var existingHiddenField = ASPx.GetElementById(this.GetStateHiddenFieldID());
    this.hiddenFields[id] = hiddenField = existingHiddenField || ASPx.CreateHiddenField(name, id);
    if(existingHiddenField)
     return existingHiddenField;
    if(beforeElement)
     parent.insertBefore(hiddenField, beforeElement)
    else
     parent.appendChild(hiddenField);
   }
  }
  return hiddenField;
 },
 GetChildElement: function(idPostfix){
  var mainElement = this.GetMainElement();
  if(idPostfix.charAt && idPostfix.charAt(0) !== "_")
   idPostfix = "_" + idPostfix;
  return mainElement ? ASPx.CacheHelper.GetCachedChildById(this, mainElement, this.name + idPostfix) : null;
 },
 getChildControl: function(idPostfix) {
  var result = null;
  var childControlId = this.getChildControlUniqueID(idPostfix);
  ASPx.GetControlCollection().ProcessControlsInContainer(this.GetMainElement(), function(control) {
   if(control.uniqueID == childControlId)
    result = control;
  });
  return result;  
 },
 getChildControlUniqueID: function(idPostfix) {
  idPostfix = idPostfix.split("_").join("$");
  if(idPostfix.charAt && idPostfix.charAt(0) !== "$")
   idPostfix = "$" + idPostfix;
  return this.uniqueID + idPostfix;  
 },
 getInnerControl: function(idPostfix) {
  var name = this.name + idPostfix;
  var result = window[name];
  return result && Ident.IsASPxClientControl(result)
   ? result
   : null;
 },
 GetParentForm: function(){
  return ASPx.GetParentByTagName(this.GetMainElement(), "FORM");
 },
 GetMainElement: function(){
  if(!ASPx.IsExistsElement(this.mainElement))
   this.mainElement = ASPx.GetElementById(this.name);
  return this.mainElement;
 },
 IsLoadingContainerVisible: function(){
  return this.IsVisible();
 },
 GetLoadingPanelElement: function(){
  return ASPx.GetElementById(this.name + "_LP");
 },
 GetClonedLoadingPanel: function(){
  return document.getElementById(this.GetLoadingPanelElement().id + "V"); 
 },
 CloneLoadingPanel: function(element, parent) {
  var clone = element.cloneNode(true);
  clone.id = element.id + "V";
  parent.appendChild(clone);
  return clone;
 },
 CreateLoadingPanelWithoutBordersInsideContainer: function(container) {
  var loadingPanel = this.CreateLoadingPanelInsideContainer(container, false, true, true);
  var contentStyle = ASPx.GetCurrentStyle(container);
  if(!loadingPanel || !contentStyle)
   return;
  var elements = [ ];
  var table = (loadingPanel.tagName == "TABLE") ? loadingPanel : ASPx.GetNodeByTagName(loadingPanel, "TABLE", 0);
  if(table != null)
   elements.push(table);
  else
   elements.push(loadingPanel);
  var cells = ASPx.GetNodesByTagName(loadingPanel, "TD");
  if(!cells) cells = [ ];
  for(var i = 0; i < cells.length; i++)
   elements.push(cells[i]);
  for(var i = 0; i < elements.length; i++) {
   var el = elements[i];
   el.style.backgroundColor = contentStyle.backgroundColor;
   ASPx.RemoveBordersAndShadows(el);
  }
 },
 CreateLoadingPanelInsideContainer: function(parentElement, hideContent, collapseHeight, collapseWidth) {
  if(this.ShouldHideExistingLoadingElements())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingElements = true;
   return null;
  }
  var element = this.GetLoadingPanelElement();
  if(element != null){
   var width = collapseWidth ? 0 : ASPx.GetClearClientWidth(parentElement);
   var height = collapseHeight ? 0 : ASPx.GetClearClientHeight(parentElement);
   if(hideContent){
    for(var i = parentElement.childNodes.length - 1; i > -1; i--){
     if(parentElement.childNodes[i].style)
      parentElement.childNodes[i].style.display = "none";
     else if(parentElement.childNodes[i].nodeType == 3) 
      parentElement.removeChild(parentElement.childNodes[i]);
    }
   }
   else
    parentElement.innerHTML = "";
   var table = document.createElement("TABLE");
   parentElement.appendChild(table);
   table.border = 0;
   table.cellPadding = 0;
   table.cellSpacing = 0;
   ASPx.SetStyles(table, {
    width: (width > 0) ? width : "100%",
    height: (height > 0) ? height : "100%"
   });
   var tbody = document.createElement("TBODY");
   table.appendChild(tbody);
   var tr = document.createElement("TR");
   tbody.appendChild(tr);
   var td = document.createElement("TD");
   tr.appendChild(td);
   td.align = "center";
   td.vAlign = "middle";
   element = this.CloneLoadingPanel(element, td);
   ASPx.SetElementDisplay(element, true, true);
   this.loadingPanelElement = element;
   return element;
  } else
   parentElement.innerHTML = "&nbsp;";
  return null;
 },
 CreateLoadingPanelWithAbsolutePosition: function(parentElement, offsetElement) {
  if(this.ShouldHideExistingLoadingElements())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingElements = true;
   return null;
  }
  if(!offsetElement)
   offsetElement = parentElement;
  var element = this.GetLoadingPanelElement();
  if(element != null) {
   element = this.CloneLoadingPanel(element, parentElement);
   ASPx.SetStyles(element, {
    position: "absolute"
   });
   ASPx.SetElementDisplay(element, true, true);
   ASPx.Evt.AttachEventToElement(element, ASPx.Evt.GetMouseWheelEventName(), ASPx.Evt.PreventEvent);
   this.SetLoadingPanelLocation(offsetElement, element);
   this.loadingPanelElement = element;
   return element;
  }
  return null;
 },
 CreateLoadingPanelInline: function(parentElement, centerInParent){
  if(this.ShouldHideExistingLoadingElements())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingElements = true;
   return null;
  }
  var element = this.GetLoadingPanelElement();
  if(element != null) {
   element = this.CloneLoadingPanel(element, parentElement);
   if(centerInParent){
    ASPx.SetElementDisplay(element, true, true, true);
    parentElement.style.textAlign = "center";
   }
   else
    ASPx.SetElementDisplay(element, true);
   this.loadingPanelElement = element;
   return element;
  }
  return null;
 },
 ShowLoadingPanel: function() {
 },
 ShowLoadingElements: function() {
  if(this.InCallback() || this.lpTimer > -1) return;
  this.ShowLoadingDiv();
  if(this.IsCallbackAnimationEnabled())
   this.StartBeginCallbackAnimation();
  else
   this.ShowLoadingElementsInternal();
 },
 ShowLoadingElementsInternal: function() {
  if(this.lpDelay > 0 && !this.IsCallbackAnimationEnabled()) 
   this.lpTimer = window.setTimeout(function() { 
    this.ShowLoadingPanelOnTimer(); 
   }.aspxBind(this), this.lpDelay);
  else {
   this.RestoreLoadingDivOpacity();
   this.ShowLoadingPanel();
  }
 },
 GetLoadingPanelOffsetElement: function (baseElement) {
  if(this.IsCallbackAnimationEnabled()) {
   var element = this.GetLoadingPanelCallbackAnimationOffsetElement();
   if(element) {
    var container = typeof(ASPx.AnimationHelper) != "undefined" ? ASPx.AnimationHelper.findSlideAnimationContainer(element) : null;
    if(container)
     return container.parentNode.parentNode;
    else
     return element;
   }
  }
  return baseElement;
 },
 GetLoadingPanelCallbackAnimationOffsetElement: function () {
  return this.GetCallbackAnimationElement();
 },
 IsCallbackAnimationEnabled: function () {
  return (this.enableCallbackAnimation || this.isSlideCallbackAnimationEnabled()) && !this.isCallbackAnimationPrevented;
 },
 GetDefaultanimationEngineType: function() {
  return ASPx.AnimationEngineType.DEFAULT;
 },
 StartBeginCallbackAnimation: function () {
  this.beginCallbackAnimationProcessing = true;
  this.isCallbackFinished = false;
  var element = this.GetCallbackAnimationElement();
  if(element && this.isSlideCallbackAnimationEnabled() && this.slideAnimationDirection) 
   ASPx.AnimationHelper.slideOut(element, this.slideAnimationDirection, this.FinishBeginCallbackAnimation.aspxBind(this), this.GetDefaultanimationEngineType());
  else if(element && this.enableCallbackAnimation) 
   ASPx.AnimationHelper.fadeOut(element, this.FinishBeginCallbackAnimation.aspxBind(this));
  else
   this.FinishBeginCallbackAnimation();
 },
 CancelBeginCallbackAnimation: function() {
  if(this.beginCallbackAnimationProcessing) {
   this.beginCallbackAnimationProcessing = false;
   var element = this.GetCallbackAnimationElement();
   ASPx.AnimationHelper.cancelAnimation(element);
  }
 },
 FinishBeginCallbackAnimation: function () {
  this.beginCallbackAnimationProcessing = false;
  if(!this.isCallbackFinished)
   this.ShowLoadingElementsInternal();
  else {
   this.DoCallback(this.savedCallbackResult);
   this.savedCallbackResult = null;
  }
 },
 CheckBeginCallbackAnimationInProgress: function(callbackResult) {
  if(this.beginCallbackAnimationProcessing) {
   this.savedCallbackResult = callbackResult;
   this.isCallbackFinished = true;
   return true;
  }
  return false;
 },
 StartEndCallbackAnimation: function () {
  this.HideLoadingPanel();
  this.SetInitialLoadingDivOpacity();
  this.RaiseEndCallbackAnimationStart();
  this.endCallbackAnimationProcessing = true;
  var element = this.GetCallbackAnimationElement();
  if(element && this.isSlideCallbackAnimationEnabled() && this.slideAnimationDirection) 
   ASPx.AnimationHelper.slideIn(element, this.slideAnimationDirection, this.FinishEndCallbackAnimation.aspxBind(this), this.GetDefaultanimationEngineType());
  else if(element && this.enableCallbackAnimation) 
   ASPx.AnimationHelper.fadeIn(element, this.FinishEndCallbackAnimation.aspxBind(this));
  else
   this.FinishEndCallbackAnimation();
  this.slideAnimationDirection = null;
 },
 FinishEndCallbackAnimation: function () {
  this.DoEndCallback();
  this.endCallbackAnimationProcessing = false;
  this.CheckRepeatGesture();
 },
 CheckEndCallbackAnimationNeeded: function() {
  if(!this.endCallbackAnimationProcessing && this.requestCount == 1) {
   this.StartEndCallbackAnimation();
   return true;
  }
  return false;
 },
 PreventCallbackAnimation: function() {
  this.isCallbackAnimationPrevented = true;
 },
 GetCallbackAnimationElement: function() {
  return null;
 },
 AssignSlideAnimationDirectionByPagerArgument: function(arg, currentPageIndex) {
  this.slideAnimationDirection = null;
  if(this.isSlideCallbackAnimationEnabled() && typeof(ASPx.AnimationHelper) != "undefined") {
   if(arg == PagerCommands.Next || arg == PagerCommands.Last)
    this.slideAnimationDirection = ASPx.AnimationHelper.SLIDE_LEFT_DIRECTION;
   else if(arg == PagerCommands.First || arg == PagerCommands.Prev)
    this.slideAnimationDirection = ASPx.AnimationHelper.SLIDE_RIGHT_DIRECTION;
   else if(!isNaN(currentPageIndex) && arg.indexOf(PagerCommands.PageNumber) == 0) {
    var newPageIndex = parseInt(arg.substring(2));
    if(!isNaN(newPageIndex))
     this.slideAnimationDirection = newPageIndex < currentPageIndex ? ASPx.AnimationHelper.SLIDE_RIGHT_DIRECTION : ASPx.AnimationHelper.SLIDE_LEFT_DIRECTION;
   }
  }
 },
 TryShowPhantomLoadingElements: function () {
  if(this.hasPhantomLoadingElements && this.InCallback()) {
   this.hasPhantomLoadingElements = false;
   this.ShowLoadingDivAndPanel();
  }
 },
 ShowLoadingDivAndPanel: function () {
  this.ShowLoadingDiv();
  this.RestoreLoadingDivOpacity();
  this.ShowLoadingPanel();
 },
 HideLoadingElements: function() {
  this.CancelBeginCallbackAnimation();
  this.HideLoadingPanel();
  this.HideLoadingDiv();
 },
 ShowLoadingPanelOnTimer: function() {
  this.ClearLoadingPanelTimer();
  if(!this.IsDOMDisposed()) {
   this.RestoreLoadingDivOpacity();
   this.ShowLoadingPanel();
  }
 },
 ClearLoadingPanelTimer: function() {
  this.lpTimer = ASPx.Timer.ClearTimer(this.lpTimer);  
 },
 HideLoadingPanel: function() {
  this.ClearLoadingPanelTimer();
  this.hasPhantomLoadingElements = false;
  if(ASPx.IsExistsElement(this.loadingPanelElement)) {
   ASPx.RemoveElement(this.loadingPanelElement);
   this.loadingPanelElement = null;
  }
 },
 SetLoadingPanelLocation: function(offsetElement, loadingPanel, x, y, offsetX, offsetY) {
  if(!ASPx.IsExists(x) || !ASPx.IsExists(y)){
   var x1 = ASPx.GetAbsoluteX(offsetElement);
   var y1 = ASPx.GetAbsoluteY(offsetElement);
   var x2 = x1;
   var y2 = y1;
   if(offsetElement == document.body){
    x2 += ASPx.GetDocumentMaxClientWidth();
    y2 += ASPx.GetDocumentMaxClientHeight();
   }
   else{
    x2 += offsetElement.offsetWidth;
    y2 += offsetElement.offsetHeight;
   }
   if(x1 < ASPx.GetDocumentScrollLeft())
    x1 = ASPx.GetDocumentScrollLeft();
   if(y1 < ASPx.GetDocumentScrollTop())
    y1 = ASPx.GetDocumentScrollTop();
   if(x2 > ASPx.GetDocumentScrollLeft() + ASPx.GetDocumentClientWidth())
    x2 = ASPx.GetDocumentScrollLeft() + ASPx.GetDocumentClientWidth();
   if(y2 > ASPx.GetDocumentScrollTop() + ASPx.GetDocumentClientHeight())
    y2 = ASPx.GetDocumentScrollTop() + ASPx.GetDocumentClientHeight();
   x = x1 + ((x2 - x1 - loadingPanel.offsetWidth) / 2);
   y = y1 + ((y2 - y1 - loadingPanel.offsetHeight) / 2);
  }
  if(ASPx.IsExists(offsetX) && ASPx.IsExists(offsetY)){
   x += offsetX;
   y += offsetY;
  }
  x = ASPx.PrepareClientPosForElement(x, loadingPanel, true);
  y = ASPx.PrepareClientPosForElement(y, loadingPanel, false);
  if(ASPx.Browser.IE && ASPx.Browser.Version > 8 && (y - Math.floor(y) === 0.5))
   y = Math.ceil(y);
  ASPx.SetStyles(loadingPanel, { left: x, top: y });
 },
 GetLoadingDiv: function(){
  return ASPx.GetElementById(this.name + "_LD");
 },
 CreateLoadingDiv: function(parentElement, offsetElement){
  if(this.ShouldHideExistingLoadingElements())
   this.HideLoadingDiv();
  if(parentElement == null) 
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingElements = true;
   return null;
  }
  if(!offsetElement)
   offsetElement = parentElement;
  var div = this.GetLoadingDiv();
  if(div != null){
   div = div.cloneNode(true);
   parentElement.appendChild(div);
   ASPx.SetElementDisplay(div, true, true);
   ASPx.Evt.AttachEventToElement(div, ASPx.TouchUIHelper.touchMouseDownEventName, ASPx.Evt.PreventEvent);
   ASPx.Evt.AttachEventToElement(div, ASPx.TouchUIHelper.touchMouseMoveEventName, ASPx.Evt.PreventEvent);
   ASPx.Evt.AttachEventToElement(div, ASPx.TouchUIHelper.touchMouseUpEventName, ASPx.Evt.PreventEvent);
   ASPx.Evt.AttachEventToElement(div, ASPx.Evt.GetMouseWheelEventName(), ASPx.Evt.PreventEvent);
   this.SetLoadingDivBounds(offsetElement, div);
   this.loadingDivElement = div;
   this.SetInitialLoadingDivOpacity();
   return div;
  }
  return null;
 },
 SetInitialLoadingDivOpacity: function() {
  if(!this.loadingDivElement) return;
  ASPx.Attr.SaveStyleAttribute(this.loadingDivElement, "opacity");
  ASPx.Attr.SaveStyleAttribute(this.loadingDivElement, "filter");
  ASPx.SetElementOpacity(this.loadingDivElement, 0.01);
 },
 RestoreLoadingDivOpacity: function() {
  if(!this.loadingDivElement) return;
  ASPx.Attr.RestoreStyleAttribute(this.loadingDivElement, "opacity");
  ASPx.Attr.RestoreStyleAttribute(this.loadingDivElement, "filter");
 },
 SetLoadingDivBounds: function(offsetElement, loadingDiv) {
  var absX = (offsetElement == document.body) ? 0 : ASPx.GetAbsoluteX(offsetElement);
  var absY = (offsetElement == document.body) ? 0 : ASPx.GetAbsoluteY(offsetElement);
  ASPx.SetStyles(loadingDiv, {
   left: ASPx.PrepareClientPosForElement(absX, loadingDiv, true),
   top: ASPx.PrepareClientPosForElement(absY, loadingDiv, false)
  });
  var width = (offsetElement == document.body) ? ASPx.GetDocumentWidth() : offsetElement.offsetWidth;
  var height = (offsetElement == document.body) ? ASPx.GetDocumentHeight() : offsetElement.offsetHeight;
  if(height < 0) 
   height = 0;
  ASPx.SetStyles(loadingDiv, { width: width, height: height });
  var correctedWidth = 2 * width - loadingDiv.offsetWidth;
  if(correctedWidth <= 0) correctedWidth = width;
  var correctedHeight = 2 * height - loadingDiv.offsetHeight;
  if(correctedHeight <= 0) correctedHeight = height;
  ASPx.SetStyles(loadingDiv, { width: correctedWidth, height: correctedHeight });
 },
 ShowLoadingDiv: function() {
 },
 HideLoadingDiv: function() {
  this.hasPhantomLoadingElements = false;
  if(ASPx.IsExistsElement(this.loadingDivElement)){
   ASPx.RemoveElement(this.loadingDivElement);
   this.loadingDivElement = null;
  }
 },
 CanHandleGesture: function(evt) {
  return false;
 },
 CanHandleGestureCore: function(evt) {
  var source = ASPx.Evt.GetEventSource(evt);
  if(ASPx.GetIsParent(this.loadingPanelElement, source) || ASPx.GetIsParent(this.loadingDivElement, source))
   return true; 
  var callbackAnimationElement = this.GetCallbackAnimationElement();
  if(!callbackAnimationElement)
   return false;
  var animationContainer = ASPx.AnimationHelper.getSlideAnimationContainer(callbackAnimationElement, false, false);
  if(animationContainer && ASPx.GetIsParent(animationContainer, source) && !ASPx.GetIsParent(animationContainer.childNodes[0], source))
   return true; 
  return this.CanHandleGesture(evt); 
 },
 AllowStartGesture: function() {
  return !this.beginCallbackAnimationProcessing && !this.endCallbackAnimationProcessing;
 },
 StartGesture: function() {
 },
 AllowExecuteGesture: function(value) {
  return false;
 },
 ExecuteGesture: function(value) {
 },
 CancelGesture: function(value) {
  if(this.repeatedGestureCount === 0) {
   this.repeatedGestureValue = value;
   this.repeatedGestureCount = 1;
  }
  else {
   if(this.repeatedGestureValue * value > 0)
    this.repeatedGestureCount++;
   else
    this.repeatedGestureCount--;
   if(this.repeatedGestureCount === 0)
    this.repeatedGestureCount = 0;
  }
 },
 CheckRepeatGesture: function() {
  if(this.repeatedGestureCount !== 0) {
   if(this.AllowExecuteGesture(this.repeatedGestureValue))
    this.ExecuteGesture(this.repeatedGestureValue, this.repeatedGestureCount);
   this.repeatedGestureValue = 0;
   this.repeatedGestureCount = 0;
  }
 },
 AllowExecutePagerGesture: function (pageIndex, pageCount, value) {
  if(pageIndex < 0) return false;
  if(pageCount <= 1) return false;
  if(value > 0 && pageIndex === 0) return false;
  if(value < 0 && pageIndex === pageCount - 1) return false;
  return true;
 },
 ExecutePagerGesture: function(pageIndex, pageCount, value, count, method) {
  if(!count) count = 1;
  var pageIndex = pageIndex + (value < 0 ? count : -count);
  if(pageIndex < 0) pageIndex = 0;
  if(pageIndex > pageCount - 1) pageIndex = pageCount - 1;
  method(PagerCommands.PageNumber + pageIndex);
 },
 RaiseInit: function(){
  if(!this.Init.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.Init.FireEvent(this, args);
  }
 },
 RaiseBeginCallbackInternal: function(command){
  if(!this.BeginCallback.IsEmpty()){
   var args = new ASPxClientBeginCallbackEventArgs(command);
   this.BeginCallback.FireEvent(this, args);
  }
 },
 RaiseEndCallbackInternal: function() {
  if(!this.EndCallback.IsEmpty()){
   var args = new ASPxClientEndCallbackEventArgs();
   this.EndCallback.FireEvent(this, args);
  }
 },
 RaiseCallbackErrorInternal: function(message, callbackId) {
  if(!this.CallbackError.IsEmpty()) {
   var args = new ASPxClientCallbackErrorEventArgs(message, callbackId);
   this.CallbackError.FireEvent(this, args);
   if(args.handled)
    return { isHandled: true, errorMessage: args.message };
  }
 },
 RaiseBeginCallback: function(command){
  this.RaiseBeginCallbackInternal(command);    
  aspxGetControlCollection().RaiseBeginCallback(this, command);
 },
 RaiseEndCallback: function(){
  this.RaiseEndCallbackInternal();
  aspxGetControlCollection().RaiseEndCallback(this);
 },
 RaiseCallbackError: function (message, callbackId) {
  var result = this.RaiseCallbackErrorInternal(message, callbackId);
  if(!result) 
   result = aspxGetControlCollection().RaiseCallbackError(this, message, callbackId);
  return result;
 },
 RaiseEndCallbackAnimationStart: function(){
  if(!this.EndCallbackAnimationStart.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.EndCallbackAnimationStart.FireEvent(this, args);
  }
 },
 RaiseBeforePronounce: function(message) {
  var args = new ASPxClientControlBeforePronounceEventArgs(message, this);
  if(!this.BeforePronounce.IsEmpty())
   this.BeforePronounce.FireEvent(this, args);
  return args;
 },
 SendMessageToAssistiveTechnology: function(message) {
  if(!this.accessibilityCompliant)
   return;
  this.PronounceMessageInternal(message, ASPx.AccessibilityPronouncerType.live);
 },
 PronounceMessageInternal: function(messageArg, type) {
  var message = messageArg;
  if(!ASPx.Ident.IsArray(messageArg))
   message = [messageArg];
  var args = this.RaiseBeforePronounce(message);
  ASPx.AccessibilityPronouncer.Pronounce(args, type);
 },
 IsVisible: function() {
  var element = this.GetMainElement();
  return ASPx.IsElementVisible(element);
 },
 IsDisplayedElement: function(element) {
  while(element && element.tagName != "BODY") {
   if(!ASPx.GetElementDisplay(element)) 
    return false;
   element = element.parentNode;
  }
  return true;
 },
 IsDisplayed: function() {
  return this.IsDisplayedElement(this.GetMainElement());
 },
 IsHiddenElement: function(element) {
  return element && element.offsetWidth == 0 && element.offsetHeight == 0;
 },
 IsHidden: function() {
  return this.IsHiddenElement(this.GetMainElement());
 },
 Focus: function() {
 },
 GetClientVisible: function(){
  return this.GetVisible();
 },
 SetClientVisible: function(visible){
  this.SetVisible(visible);
 },
 GetVisible: function(){
  return this.clientVisible;
 },
 SetVisible: function(visible){
  if(this.clientVisible != visible){
   this.clientVisible = visible;
   ASPx.SetElementDisplay(this.GetMainElement(), visible);
   if(visible) {
    this.AdjustControl();
    var mainElement = this.GetMainElement();
    if(mainElement)
     aspxGetControlCollection().AdjustControls(mainElement);
   }
  }
 },
 GetEnabled: function() {
  return this.clientEnabled;
 },
 SetEnabled: function(enabled) {
  this.clientEnabled = enabled;
  if(ASPxClientControl.setEnabledLocked)
   return;
  else
   ASPxClientControl.setEnabledLocked = true;
  this.savedClientEnabled = enabled;
  aspxGetControlCollection().ProcessControlsInContainer(this.GetMainElement(), function(control) {
   if(ASPx.IsFunction(control.SetEnabled))
    control.SetEnabled(enabled && control.savedClientEnabled);
  });
  delete ASPxClientControl.setEnabledLocked;
 },
 InCallback: function() {
  return this.requestCount > 0;
 },
 DoBeginCallback: function(command) {
  this.RaiseBeginCallback(command || "");
  aspxGetControlCollection().Before_WebForm_InitCallback(this.name);
  if(typeof(WebForm_InitCallback) != "undefined" && WebForm_InitCallback) {
   __theFormPostData = "";
   __theFormPostCollection = [ ];
   this.ClearPostBackEventInput("__EVENTTARGET");
   this.ClearPostBackEventInput("__EVENTARGUMENT");
   WebForm_InitCallback();
   this.savedFormPostData = __theFormPostData;   
   this.savedFormPostCollection = __theFormPostCollection;
  }
 },
 ClearPostBackEventInput: function(id){
  var element = ASPx.GetElementById(id);
  if(element != null) element.value = "";
 },
 PerformDataCallback: function(arg, handler) {
  this.CreateCustomDataCallback(arg, "", handler);
 },
 sendCallbackViaQueue: function (prefix, arg, showLoadingPanel, context, handler) {
  if (!this.useCallbackQueue())
   return false;
  var context = context || this;
  var token = this.callbackQueueHelper.sendCallback(ASPx.FormatCallbackArg(prefix, arg), context, handler || context.OnCallback, prefix);
  if (showLoadingPanel)
   this.callbackQueueHelper.showLoadingElements();
  return token;
 },
 CreateCallback: function (arg, command, handler) {
  var callbackInfo = this.CreateCallbackInfo(ASPx.CallbackType.Common, handler || null);
  var callbackID = this.CreateCallbackByInfo(arg, command, callbackInfo);
  return callbackID;
 },
 CreateCustomDataCallback: function(arg, command, handler) {
  var callbackInfo = this.CreateCallbackInfo(ASPx.CallbackType.Data, handler);
  this.CreateCallbackByInfo(arg, command, callbackInfo);
 },
 CreateCallbackByInfo: function(arg, command, callbackInfo) {
  if(!this.CanCreateCallback()) return;
  var callbackID;
  if(typeof(WebForm_DoCallback) != "undefined" && WebForm_DoCallback && ASPx.documentLoaded)
   callbackID = this.CreateCallbackInternal(arg, command, true, callbackInfo);
  else {
   if(!this.savedCallbacks)
    this.savedCallbacks = [];
   var callbackInfo = { arg: arg, command: command, callbackInfo: callbackInfo };
   if(this.allowMultipleCallbacks)
    this.savedCallbacks.push(callbackInfo);
   else
    this.savedCallbacks[0] = callbackInfo;
  }
  return callbackID;
 },
 CreateCallbackInternal: function(arg, command, viaTimer, callbackInfo) {
  var watcher = ASPx.ControlUpdateWatcher.getInstance();
  if(watcher && !watcher.CanSendCallback(this, arg)) {
   this.CancelCallbackInternal();
   return;
  }
  this.requestCount++;
  this.DoBeginCallback(command);
  if(typeof(arg) == "undefined")
   arg = "";
  if(typeof(command) == "undefined")
   command = "";
  var callbackID = this.SaveCallbackInfo(callbackInfo);
  if(viaTimer)
   window.setTimeout(function() { this.CreateCallbackCore(arg, command, callbackID); }.aspxBind(this), 0);
  else
   this.CreateCallbackCore(arg, command, callbackID);
  return callbackID;
 },
 CancelCallbackInternal: function() {
  this.CancelCallbackCore();
  this.HideLoadingElements();
 },
 CancelCallbackCore: function() {
 },
 CreateCallbackCore: function(arg, command, callbackID) {
  var callBackMethod = this.GetCallbackMethod(command);
  __theFormPostData = this.savedFormPostData;
  __theFormPostCollection = this.savedFormPostCollection;
  callBackMethod.call(this, this.GetSerializedCallbackInfoByID(callbackID) + arg);
 },
 GetCallbackMethod: function(command){
  return this.callBack;
 },
 CanCreateCallback: function() {
  return !this.InCallback() || (this.allowMultipleCallbacks && !this.beginCallbackAnimationProcessing && !this.endCallbackAnimationProcessing);
 },
 DoLoadCallbackScripts: function() {
  ASPx.ProcessScriptsAndLinks(this.name, true);
 },
 DoEndCallback: function() {
  if(this.IsCallbackAnimationEnabled() && this.CheckEndCallbackAnimationNeeded()) 
   return;
  this.requestCount--;
  if (this.requestCount < 1) 
   this.callbackHandlersQueue.executeCallbacksHandlers();
  if(this.HideLoadingPanelOnCallback() && this.requestCount < 1) 
   this.HideLoadingElements();
  if(this.isSwipeGesturesEnabled() && this.supportGestures) {
   ASPx.GesturesHelper.UpdateSwipeAnimationContainer(this.name);
   if(this.touchUIMouseScroller)
    this.touchUIMouseScroller.update();
  }
  this.isCallbackAnimationPrevented = false;
  this.OnCallbackFinalized();
  this.AssignEllipsisTooltips();
  this.RaiseEndCallback();
 },
 DoFinalizeCallback: function() {
 },
 OnCallbackFinalized: function() {
 },
 AssignEllipsisTooltips: function() { },
 HideLoadingPanelOnCallback: function() {
  return true;
 },
 ShouldHideExistingLoadingElements: function() {
  return true;
 },
 EvalCallbackResult: function(resultString){
  return eval(resultString);
 },
 DoCallback: function(result) {
  if(this.IsCallbackAnimationEnabled() && this.CheckBeginCallbackAnimationInProgress(result))
   return;
  result = ASPx.Str.Trim(result);
  if(result.indexOf(ASPx.CallbackResultPrefix) != 0) 
   this.ProcessCallbackGeneralError(result);
  else {
   var resultObj = null;
   try {
    resultObj = this.EvalCallbackResult(result);
   } 
   catch(e) {
   }
   if(resultObj) {
    ASPx.CacheHelper.DropCache(this);
    if(resultObj.redirect){
     if(!ASPx.Browser.IE)
      window.location.href = resultObj.redirect;
     else { 
      var fakeLink = document.createElement("a");
      fakeLink.href = resultObj.redirect;
      document.body.appendChild(fakeLink); 
      try { fakeLink.click(); } catch(e){ } 
     }
    }
    else if(ASPx.IsExists(resultObj.generalError)){
     this.ProcessCallbackGeneralError(resultObj.generalError);
    }
    else {
     var errorObj = resultObj.error;
     if(errorObj)
      this.ProcessCallbackError(errorObj,resultObj.id);
     else {
      if(resultObj.cp) {
       for(var name in resultObj.cp)
        this[name] = resultObj.cp[name];
      }
      var callbackInfo = this.DequeueCallbackInfo(resultObj.id);
      if(callbackInfo && callbackInfo.type == ASPx.CallbackType.Data)
       this.ProcessCustomDataCallback(resultObj.result, callbackInfo);
      else {
       if (this.useCallbackQueue() && this.callbackQueueHelper.getCallbackInfoById(resultObj.id))
        this.callbackQueueHelper.processCallback(resultObj.result, resultObj.id);
       else {
        this.ProcessCallback(resultObj.result, resultObj.id);
        if(callbackInfo && callbackInfo.handler) {
         var handlerInfo = { handler: callbackInfo.handler, result: resultObj.result.data };
         this.callbackHandlersQueue.addCallbackHandler(handlerInfo);
        }
       }
      }
     }
    }
   } 
  }
  this.DoLoadCallbackScripts();
 },
 DoCallbackError: function(result) {
  this.HideLoadingElements();
  this.ProcessCallbackGeneralError(result); 
 },
 DoControlClick: function(evt) {
  this.OnControlClick(ASPx.Evt.GetEventSource(evt), evt);
 },
 ProcessCallback: function (result, callbackId) {
  this.OnCallback(result, callbackId);
 },
 ProcessCustomDataCallback: function(result, callbackInfo) {
  if(callbackInfo.handler != null)
   callbackInfo.handler(this, result);
  this.RaiseCustomDataCallback(result);
 },
 RaiseCustomDataCallback: function(result) {
  if(!this.CustomDataCallback.IsEmpty()) {
   var arg = new ASPxClientCustomDataCallbackEventArgs(result);
   this.CustomDataCallback.FireEvent(this, arg);
  }
 },
 OnCallback: function(result) {
 },
 CreateCallbackInfo: function(type, handler) {
  return { type: type, handler: handler };
 },
 GetSerializedCallbackInfoByID: function(callbackID) {
  return this.GetCallbackInfoByID(callbackID).type + callbackID + ASPx.CallbackSeparator;
 },
 SaveCallbackInfo: function(callbackInfo) {
  var activeCallbacksInfo = this.GetActiveCallbacksInfo();
  for(var i = 0; i < activeCallbacksInfo.length; i++) {
   if(activeCallbacksInfo[i] == null) {
    activeCallbacksInfo[i] = callbackInfo;
    return i;
   }
  }
  activeCallbacksInfo.push(callbackInfo);
  return activeCallbacksInfo.length - 1;
 },
 GetActiveCallbacksInfo: function() {
  var persistentProperties = this.GetPersistentProperties();
  if(!persistentProperties.activeCallbacks)
   persistentProperties.activeCallbacks = [ ];
  return persistentProperties.activeCallbacks;
 },
 GetPersistentProperties: function() {
  var storage = _aspxGetPersistentControlPropertiesStorage();
  var persistentProperties = storage[this.name];
  if(!persistentProperties) {
   persistentProperties = { };
   storage[this.name] = persistentProperties;
  }
  return persistentProperties;
 },
 GetCallbackInfoByID: function(callbackID) {
  return this.GetActiveCallbacksInfo()[callbackID];
 },
 DequeueCallbackInfo: function(index) {
  var activeCallbacksInfo = this.GetActiveCallbacksInfo();
  if(index < 0 || index >= activeCallbacksInfo.length)
   return null;
  var result = activeCallbacksInfo[index];
  activeCallbacksInfo[index] = null;
  return result;
 },
 ProcessCallbackError: function (errorObj, callbackId) {
  var data = ASPx.IsExists(errorObj.data) ? errorObj.data : null;
  var result = this.RaiseCallbackError(errorObj.message, callbackId);
  if(result.isHandled)
   this.OnCallbackErrorAfterUserHandle(result.errorMessage, data); 
  else
   this.OnCallbackError(result.errorMessage, data); 
 },
 OnCallbackError: function(errorMessage, data) {
  if(errorMessage)
   ASPx.ShowErrorAlert(errorMessage);
 },
 OnCallbackErrorAfterUserHandle: function(errorMessage, data) {
 },
 ProcessCallbackGeneralError: function(errorMessage) {
  var result = this.RaiseCallbackError(errorMessage);
  if(!result.isHandled)
   this.OnCallbackGeneralError(result.errorMessage);
 },
 OnCallbackGeneralError: function(errorMessage) {
  this.OnCallbackError(errorMessage, null);
 },
 SendPostBack: function(params) {
  if(typeof(__doPostBack) != "undefined")
   __doPostBack(this.uniqueID, params);
  else{
   var form = this.GetParentForm();
   if(form) form.submit();
  }
 },
 IsValidInstance: function () {
  return aspxGetControlCollection().GetByName(this.name) === this;
 },
 OnDispose: function() { 
  var varName = this.globalName;
  if(varName && varName !== "" && window && window[varName] && window[varName] == this){
   try{
    delete window[varName];
   }
   catch(e){  }
  }
  if(this.callbackQueueHelper)
   this.callbackQueueHelper.detachEvents();
 },
 OnGlobalControlsInitialized: function(args) { 
 },
 OnGlobalBrowserWindowResized: function(args) { 
 },
 OnGlobalBeginCallback: function(args) { 
 },
 OnGlobalEndCallback: function(args) { 
 },
 OnGlobalCallbackError: function(args) { 
 },
 OnGlobalValidationCompleted: function(args) { 
 },
 DOMContentLoaded: function() { },
 IsStateControllerEnabled: function() { return false; },
 InitializeDOM: function() {
  var mainElement = this.GetMainElement();
  if(mainElement)
   mainElement["dxinit"] = true;
 },
 IsDOMInitialized: function() {
  var mainElement = this.GetMainElement();
  return mainElement && mainElement["dxinit"];
 },
 AdjustControl: function(nestedCall) { },
 OnBrowserWindowResizeInternal: function(e) { },
 RegisterInControlTree: function(tree) { }
});
ASPxClientControlBase.Cast = function(obj) {
 if(typeof obj == "string")
  return window[obj];
 return obj;
};
var persistentControlPropertiesStorage = null;
function _aspxGetPersistentControlPropertiesStorage() {
 if(persistentControlPropertiesStorage == null)
  persistentControlPropertiesStorage = { };
 return persistentControlPropertiesStorage;
}
var ELLIPSIS_MARKER_CLASS = "dx-ellipsis";
var ELLIPSIS_TOOLTIP_MARKER_ATTR = "dxEllipsisTitle";
var ASPxClientControl = ASPx.CreateClass(ASPxClientControlBase, {
 constructor: function(name){
  this.constructor.prototype.constructor.call(this, name);
  this.rtl = false;
  this.enableEllipsis = false;
  this.isNative = false;
  this.isControlCollapsed = false;
  this.isInsideHierarchyAdjustment = false;
  this.controlOwner = null;
  this.adjustedSizes = { };
  this.dialogContentHashTable = { };
  this.renderIFrameForPopupElements = false;
  this.widthValueSetInPercentage = false;
  this.heightValueSetInPercentage = false;
  this.verticalAlignedElements = { };
  this.wrappedTextContainers = { };
  this.scrollPositionState = { };
  this.sizingConfig = {
   allowSetWidth: true,
   allowSetHeight: true,
   correction : false,
   adjustControl : false,
   supportPercentHeight: false,
   supportAutoHeight: false
  };
  this.percentSizeConfig = {
   width: -1,
   height: -1,
   markerWidth: -1,
   markerHeight: -1
  };  
 },
 InlineInitialize: function() {
  this.InitializeDOM();
  ASPxClientControlBase.prototype.InlineInitialize.call(this);
 },
 AfterCreate: function() { 
  ASPxClientControlBase.prototype.AfterCreate.call(this);
  if(!this.CanInitializeAdjustmentOnDOMContentLoaded() || ASPx.IsStartupScriptsRunning())
   this.InitializeAdjustment();
 },
 DOMContentLoaded: function() {
  if(this.CanInitializeAdjustmentOnDOMContentLoaded()) 
   this.InitializeAdjustment();
 },
 CanInitializeAdjustmentOnDOMContentLoaded: function() {
  return !ASPx.Browser.IE || ASPx.Browser.Version >= 10; 
 },
 InitializeAdjustment: function() {
  this.UpdateAdjustmentFlags();
  this.AdjustControl();
 },
 AfterInitialize: function() {
  this.AdjustControl();
  ASPxClientControlBase.prototype.AfterInitialize.call(this);
 },
 IsStateControllerEnabled: function(){
  return typeof(ASPx.GetStateController) != "undefined" && ASPx.GetStateController();
 },
 GetWidth: function() {
  return this.GetMainElement().offsetWidth;
 },
 GetHeight: function() {
  return this.GetMainElement().offsetHeight;
 },
 SetWidth: function(width) {
  if(this.sizingConfig.allowSetWidth)
   this.SetSizeCore("width", width, "GetWidth", false);
 },
 SetHeight: function(height) {
  if(this.sizingConfig.allowSetHeight)
   this.SetSizeCore("height", height, "GetHeight", false);
 },
 SetSizeCore: function(sizePropertyName, size, getFunctionName, corrected) {
  if(size < 0)
   return;
  this.GetMainElement().style[sizePropertyName] = size + "px";
  this.UpdateAdjustmentFlags(sizePropertyName);
  if(this.sizingConfig.adjustControl)
   this.AdjustControl(true);
  if(this.sizingConfig.correction && !corrected) {
   var realSize = this[getFunctionName]();
   if(realSize != size) {
    var correctedSize = size - (realSize - size);
    this.SetSizeCore(sizePropertyName, correctedSize, getFunctionName, true);
   }
  }
 },
 AdjustControl: function(nestedCall) {
  if(this.IsAdjustmentRequired() && (!ASPxClientControl.adjustControlLocked || nestedCall)) {
   ASPxClientControl.adjustControlLocked = true;
   try {
    if(!this.IsAdjustmentAllowed())
     return;
    this.AdjustControlCore();
    this.UpdateAdjustedSizes();
   } 
   finally {
    delete ASPxClientControl.adjustControlLocked;
   }
  }
  this.AssignEllipsisTooltips();
  this.TryShowPhantomLoadingElements();
 },
 ResetControlAdjustment: function () {
  this.adjustedSizes = { };
 },
 UpdateAdjustmentFlags: function(sizeProperty) {
  var mainElement = this.GetMainElement();
  if(mainElement) {
   var mainElementStyle = ASPx.GetCurrentStyle(mainElement);
   this.UpdatePercentSizeConfig([mainElementStyle.width, mainElement.style.width], [mainElementStyle.height, mainElement.style.height], sizeProperty);
  }
 },
 UpdatePercentSizeConfig: function(widths, heights, modifyStyleProperty) {
  switch(modifyStyleProperty) {
   case "width":
    this.UpdatePercentWidthConfig(widths);
    break;
   case "height":
    this.UpdatePercentHeightConfig(heights);
    break;
   default:
    this.UpdatePercentWidthConfig(widths);
    this.UpdatePercentHeightConfig(heights);
    break;
  }
  this.ResetControlPercentMarkerSize();
 },
 UpdatePercentWidthConfig: function(widths) {
  this.widthValueSetInPercentage = false;
  for(var i = 0; i < widths.length; i++) {
   if(this.IsPercentageWidth(widths[i])) {
    this.percentSizeConfig.width = widths[i];
    this.widthValueSetInPercentage = true;
    break;
   }
  }
 },
 IsPercentageWidth: function(width) { return ASPx.IsPercentageSize(width); },
 UpdatePercentHeightConfig: function(heights) {
  this.heightValueSetInPercentage = false;
    for(var i = 0; i < heights.length; i++) {
   if(ASPx.IsPercentageSize(heights[i])) {
    this.percentSizeConfig.height = heights[i];
    this.heightValueSetInPercentage = true;
    break;
   }
  }
 },
 GetAdjustedSizes: function() {
  var mainElement = this.GetMainElement();
  if(mainElement) 
   return { width: mainElement.offsetWidth, height: mainElement.offsetHeight };
  return { width: 0, height: 0 };
 },
 IsAdjusted: function() {
  return (this.adjustedSizes.width && this.adjustedSizes.width > 0) && (this.adjustedSizes.height && this.adjustedSizes.height > 0);
 },
 IsAdjustmentRequired: function() {
  if(!this.IsAdjusted())
   return true;
  if(this.widthValueSetInPercentage)
   return true;
  if(this.heightValueSetInPercentage)
   return true;
  var sizes = this.GetAdjustedSizes();
  for(var name in sizes){
   if(this.adjustedSizes[name] !== sizes[name])
    return true;
  }
  return false;
 },
 IsAdjustmentAllowed: function() {
  var mainElement = this.GetMainElement();
  return mainElement && this.IsDisplayed() && !this.IsHidden() && this.IsDOMInitialized();
 },
 UpdateAdjustedSizes: function() {
  var sizes = this.GetAdjustedSizes();
  for(var name in sizes)
   this.adjustedSizes[name] = sizes[name];
 },
 AdjustControlCore: function() {
 },
 AdjustAutoHeight: function() {
 },
 IsControlCollapsed: function() {
  return this.isControlCollapsed;
 },
 NeedCollapseControl: function() {
  return this.NeedCollapseControlCore() && this.IsAdjustmentRequired() && this.IsAdjustmentAllowed();
 },
 NeedCollapseControlCore: function() {
  return false;
 },
 CollapseEditor: function() {
 },
 CollapseControl: function() {
  this.SaveScrollPositions();
  var mainElement = this.GetMainElement(),
   marker = this.GetControlPercentSizeMarker();
  marker.style.height = this.heightValueSetInPercentage && this.sizingConfig.supportPercentHeight
   ? this.percentSizeConfig.height 
   : (mainElement.offsetHeight + "px");
  mainElement.style.display = "none";
  this.isControlCollapsed = true;
 },
 ExpandControl: function() {
  var mainElement = this.GetMainElement();
  mainElement.style.display = "";
  this.GetControlPercentSizeMarker().style.height = "0px";
  this.isControlCollapsed = false;
  this.RestoreScrollPositions();
 },
 CanCauseReadjustment: function() {
  return this.NeedCollapseControlCore();
 },
 IsExpandableByAdjustment: function() {
  return false;
 },
 HasFixedPosition: function() {
  return false;
 },
 SaveScrollPositions: function() {
  var mainElement = this.GetMainElement();
  this.scrollPositionState.outer = ASPx.GetOuterScrollPosition(mainElement.parentNode);
  this.scrollPositionState.inner = ASPx.GetInnerScrollPositions(mainElement);
 },
 RestoreScrollPositions: function() {
  ASPx.RestoreOuterScrollPosition(this.scrollPositionState.outer);
  ASPx.RestoreInnerScrollPositions(this.scrollPositionState.inner);
 },
 GetControlPercentSizeMarker: function() {
  if(this.percentSizeMarker === undefined) {
   this.percentSizeMarker = ASPx.CreateHtmlElementFromString("<div style='height:0px;font-size:0px;line-height:0;width:100%;'></div>");
   ASPx.InsertElementAfter(this.percentSizeMarker, this.GetMainElement());
  }
  return this.percentSizeMarker;
 },
 KeepControlPercentSizeMarker: function(needCollapse, needCalculateHeight) {
  var mainElement = this.GetMainElement(),
   marker = this.GetControlPercentSizeMarker(),
   markerHeight;
  if(needCollapse)
   this.CollapseControl();
  if(this.widthValueSetInPercentage && marker.style.width !== this.percentSizeConfig.width)
   marker.style.width = this.percentSizeConfig.width;
  if(needCalculateHeight) {
   if(this.IsControlCollapsed())
    markerHeight = marker.style.height;
   marker.style.height = this.percentSizeConfig.height;
  }
  this.percentSizeConfig.markerWidth = marker.offsetWidth;
  if(needCalculateHeight) {
   this.percentSizeConfig.markerHeight = marker.offsetHeight;
   if(this.IsControlCollapsed())
    marker.style.height = markerHeight;
   else
    marker.style.height = "0px";
  }
  if(needCollapse)
   this.ExpandControl();
 },
 ResetControlPercentMarkerSize: function() {
  this.percentSizeConfig.markerWidth = -1;
  this.percentSizeConfig.markerHeight = -1;
 },
 GetControlPercentMarkerSize: function(hideControl, force) {
  var needCalculateHeight = this.heightValueSetInPercentage && this.sizingConfig.supportPercentHeight;
  if(force || this.percentSizeConfig.markerWidth < 1 || (needCalculateHeight && this.percentSizeConfig.markerHeight < 1))
   this.KeepControlPercentSizeMarker(hideControl && !this.IsControlCollapsed(), needCalculateHeight);
  return {
   width: this.percentSizeConfig.markerWidth,
   height: this.percentSizeConfig.markerHeight
  };
 },
 AssignEllipsisTooltips: function() {
  if(this.RequireAssignTooltips())
   this.AssignEllipsisTooltipsCore();
 },
 AssignEllipsisTooltipsCore: function(rootElement, reassingExistingTooltips) {
  var requirePaddingManipulation = ASPx.Browser.IE || ASPx.Browser.Edge || ASPx.Browser.Firefox;
  rootElement = rootElement || this.GetMainElement();
  var nodes = this.GetEllipsisNodes(rootElement);
  var nodeInfos = [];
  var nodesCount = nodes.length;
  for(var i = 0; i < nodesCount; i++) {
   var node = nodes[i];
   var info = { node: node };
   if(requirePaddingManipulation) {
    var style = ASPx.GetCurrentStyle(node);
    info.paddingLeft = node.style.paddingLeft;
    info.totalPadding = ASPx.GetLeftRightPaddings(node, style);
   }
   nodeInfos.push(info);
  }
  if(requirePaddingManipulation) {
   for(var i = 0; i < nodesCount; i++) {
    var info = nodeInfos[i];
    ASPx.SetStyles(info.node, { paddingLeft: info.totalPadding }, true);
   }
  }
  for(var i = 0; i < nodesCount; i++) {
   var info = nodeInfos[i];
   var node = info.node;
   info.isTextShortened = node.scrollWidth > node.clientWidth;
   info.hasTitle = !!node.title;
   if(!info.hasTitle || reassingExistingTooltips)
    info.title = this.GetEllipsisTooltipText(node);
  }
  for(var i = 0; i < nodesCount; i++) {
   var info = nodeInfos[i];
   var node = info.node;
   if(info.isTextShortened && info.title) {
    ASPx.Attr.SetAttribute(node, "title", info.title);
    ASPx.Attr.SetAttribute(node, ELLIPSIS_TOOLTIP_MARKER_ATTR, true);
   }
   if(!info.isTextShortened && info.hasTitle)
    ASPx.Attr.RemoveAttribute(node, "title");
  }
  if(requirePaddingManipulation) {
   for(var i = 0; i < nodesCount; i++) {
    var info = nodeInfos[i];
    var node = info.node;
    node.style.paddingLeft = info.paddingLeft;
   }
  }
 },
 GetEllipsisNodes: function(element) {
  var ellipsibleNodes = ASPx.Data.CollectionToArray(ASPx.GetNodesByClassName(element, ELLIPSIS_MARKER_CLASS));
  if(ASPx.ElementHasCssClass(element, ELLIPSIS_MARKER_CLASS))
   ellipsibleNodes.push(element);
  return ellipsibleNodes.filter(function(node) {
   return !ASPx.Attr.IsExistsAttribute(node, "title") || ASPx.Attr.IsExistsAttribute(node, ELLIPSIS_TOOLTIP_MARKER_ATTR);
  });
 },
 GetEllipsisTooltipText: function(element) {
  if(element && ASPx.IsExists(element.innerText))
   return element.innerText;
  return ASPx.GetInnerText(element);
 },
 RequireAssignTooltips: function() {
  return this.enableEllipsis && !ASPx.Browser.MobileUI;
 },
 OnBrowserWindowResize: function(e) {
 },
 OnBrowserWindowResizeInternal: function(e){
  if(this.BrowserWindowResizeSubscriber()) 
   this.OnBrowserWindowResize(e);
 },
 BrowserWindowResizeSubscriber: function() {
  return this.widthValueSetInPercentage || !this.IsAdjusted();
 },
 ShrinkWrappedText: function(getElements, key, reCorrect) {
  if(!ASPx.Browser.Safari) return;
  var elements = ASPx.CacheHelper.GetCachedElements(this, key, getElements, this.wrappedTextContainers);
  for(var i = 0; i < elements.length; i++)
   this.ShrinkWrappedTextInContainer(elements[i], reCorrect);
 },
 ShrinkWrappedTextInContainer: function(container, reCorrect) {
  if(!ASPx.Browser.Safari || !container || (container.dxWrappedTextShrinked && !reCorrect) || container.offsetWidth === 0) return;
  ASPx.ShrinkWrappedTextInContainer(container);
  container.dxWrappedTextShrinked = true;
 },
 CorrectWrappedText: function(getElements, key, reCorrect) {
  var elements = ASPx.CacheHelper.GetCachedElements(this, key, getElements, this.wrappedTextContainers);
  for(var i = 0; i < elements.length; i++)
   this.CorrectWrappedTextInContainer(elements[i], reCorrect);
 },
 CorrectWrappedTextInContainer: function(container, reCorrect) {
  if(!container || (container.dxWrappedTextCorrected && !reCorrect) || container.offsetWidth === 0) return;
  ASPx.AdjustWrappedTextInContainer(container);
  container.dxWrappedTextCorrected = true;
 },
 CorrectVerticalAlignment: function(alignMethod, getElements, key, reAlign) {
  var elements = ASPx.CacheHelper.GetCachedElements(this, key, getElements, this.verticalAlignedElements);
  for(var i = 0; i < elements.length; i++)
   this.CorrectElementVerticalAlignment(alignMethod, elements[i], reAlign);
 },
 CorrectElementVerticalAlignment: function(alignMethod, element, reAlign) {
  if(!element || (element.dxVerticalAligned && !reAlign) || element.offsetHeight === 0) return;
  alignMethod(element);
  element.dxVerticalAligned = true;
 },
 ClearVerticalAlignedElementsCache: function() {
  ASPx.CacheHelper.DropCache(this.verticalAlignedElements);
 },
 ClearWrappedTextContainersCache: function() {
  ASPx.CacheHelper.DropCache(this.wrappedTextContainers);
 },
 AdjustPagerControls: function() {
  if(typeof(ASPx.GetPagersCollection) != "undefined")
   ASPx.GetPagersCollection().AdjustControls(this.GetMainElement());
 },
 RegisterInControlTree: function(tree) {
  var mainElement = this.GetMainElement();
  if(mainElement && mainElement.id)
   tree.createNode(mainElement.id, this);
 },
 GetItemElementName: function(element) {
  var name = "";
  if(element.id)
   name = element.id.substring(this.name.length + 1);
  return name;
 },
 GetLinkElement: function(element) {
  if(element == null) return null;
  return (element.tagName == "A") ? element : ASPx.GetNodeByTagName(element, "A", 0);
 },
 GetInternalHyperlinkElement: function(parentElement, index) {
  var element = ASPx.GetNodeByTagName(parentElement, "A", index);
  if(element == null) 
   element = ASPx.GetNodeByTagName(parentElement, "SPAN", index);
  return element;
 },
 OnControlClick: function(clickedElement, htmlEvent) {
 }
});
ASPxClientControl.Cast = function(obj) {
 if(typeof obj == "string")
  return window[obj];
 return obj;
};
ASPxClientControl.AdjustControls = function(container, collapseControls){
 aspxGetControlCollection().AdjustControls(container, collapseControls);
};
ASPxClientControl.GetControlCollection = function(){
 return aspxGetControlCollection();
}
ASPxClientControl.LeadingAfterInitCallConsts = {
 None: 0,
 Direct: 1,
 Reverse: 2
};
var ASPxClientComponent = ASPx.CreateClass(ASPxClientControl, {
 constructor: function (name) {
  this.constructor.prototype.constructor.call(this, name);
 },
 IsDOMDisposed: function() { 
  return false;
 }
});
var ASPxClientControlCollection = ASPx.CreateClass(ASPx.CollectionBase, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
  this.prevWndWidth = "";
  this.prevWndHeight = "";
  this.requestCountInternal = 0; 
  this.BeforeInitCallback = new ASPxClientEvent();
  this.ControlsInitialized = new ASPxClientEvent();
  this.BrowserWindowResized = new ASPxClientEvent();
  this.BeginCallback = new ASPxClientEvent();
  this.EndCallback = new ASPxClientEvent();
  this.CallbackError = new ASPxClientEvent();
  this.ValidationCompleted = new ASPxClientEvent();
  aspxGetControlCollectionCollection().Add(this);
 },
 Add: function(element) {
  var existsElement = this.Get(element.name);
  if(existsElement && existsElement !== element) 
   this.Remove(existsElement);
  ASPx.CollectionBase.prototype.Add.call(this, element.name, element);
 },
 Remove: function(element) {
  if(element && element instanceof ASPxClientControl)
   element.OnDispose();
  ASPx.CollectionBase.prototype.Remove.call(this, element.name);
 },
 GetGlobal: function(name) {
  var result = window[name];
  return result && Ident.IsASPxClientControl(result)
   ? result
   : null;
 },
 GetByName: function(name){
  return this.Get(name) || this.GetGlobal(name);
 },
 GetCollectionType: function(){
  return ASPxClientControlCollection.BaseCollectionType;
 },
 GetControlsByPredicate: function(predicate) {
  var result = [];
  this.ForEachControl(function(control) {
   if(!predicate || predicate(control))
    result.push(control);
  });
  return result;
 },
 GetControlsByType: function(type) {
  return this.GetControlsByPredicate(function(control) { 
   return type && (control instanceof type);
  });
 },
 ForEachControl: function(action, context) {
  context = context || this;
  this.elementsMap.forEachEntry(function(name, control) {
   if(Ident.IsASPxClientControl(control))
    return action.call(context, control);
  }, context);
 },
 forEachControlHierarchy: function(container, context, collapseControls, processFunc) {
  context = context || this;
  var controlTree = new ASPx.ControlTree(this, container);
  controlTree.forEachControl(collapseControls, function(control) {
   processFunc.call(context, control);
  });
 },
 AdjustControls: function(container, collapseControls) {
  container = container || null;
  window.setTimeout(function() {
   this.AdjustControlsCore(container, collapseControls);
  }.aspxBind(this), 0);
 },
 AdjustControlsCore: function(container, collapseControls) {
  this.forEachControlHierarchy(container, this, collapseControls, function(control) {
   control.AdjustControl();
  });
 },
 CollapseControls: function(container) {
  this.ProcessControlsInContainer(container, function(control) {
   if(control.isASPxClientEdit)
    control.CollapseEditor();
   else if(!!window.ASPxClientRibbon && control instanceof ASPxClientRibbon)
    control.CollapseControl();
  });
 },
 AtlasInitialize: function(isCallback) {
  if(ASPx.Browser.IE && ASPx.Browser.MajorVersion < 9) {
   var func = function() {
    if(_aspxIsLinksLoaded())
     ASPx.ProcessScriptsAndLinks("", isCallback); 
    else
     setTimeout(func, 100);
   }   
   func();
  }
  else
   ASPx.ProcessScriptsAndLinks("", isCallback);
 },
 DOMContentLoaded: function() {
  this.ForEachControl(function(control){
    control.DOMContentLoaded();
  });
 },
 Initialize: function() {
  ASPx.GetPostHandler().Post.AddHandler(
   function(s, e) { this.OnPost(e); }.aspxBind(this)
  );
  ASPx.GetPostHandler().PostFinalization.AddHandler(
   function(s, e) { this.OnPostFinalization(e); }.aspxBind(this)
  );
  this.InitializeElements(false );
  if(typeof(Sys) != "undefined" && typeof(Sys.Application) != "undefined") {
   var checkIsInitialized = function() {
    if(Sys.Application.get_isInitialized())
     Sys.Application.add_load(aspxCAInit);
    else
     setTimeout(checkIsInitialized, 0);
   }
   checkIsInitialized();
  }
  this.InitWindowSizeCache();
 },
 InitializeElements: function(isCallback) {
  this.ForEachControl(function(control){
   if(!control.isInitialized)
    control.Initialize();
  });
  this.AfterInitializeElementsLeadingCall();
  this.AfterInitializeElements();
  this.RaiseControlsInitialized(isCallback);
 },
 AfterInitializeElementsLeadingCall: function() {
  var controls = {};
  controls[ASPxClientControl.LeadingAfterInitCallConsts.Direct] = [];
  controls[ASPxClientControl.LeadingAfterInitCallConsts.Reverse] = [];
  this.ForEachControl(function(control) {
   if(control.leadingAfterInitCall != ASPxClientControl.LeadingAfterInitCallConsts.None && !control.isInitialized)
    controls[control.leadingAfterInitCall].push(control);
  });
  var directInitControls = controls[ASPxClientControl.LeadingAfterInitCallConsts.Direct],
   reverseInitControls = controls[ASPxClientControl.LeadingAfterInitCallConsts.Reverse];
  for(var i = 0, control; control = directInitControls[i]; i++)
   control.AfterInitialize();
  for(var i = reverseInitControls.length - 1, control; control = reverseInitControls[i]; i--)
   control.AfterInitialize();
 },
 AfterInitializeElements: function() {
  this.ForEachControl(function(control) {
   if(control.leadingAfterInitCall == ASPxClientControl.LeadingAfterInitCallConsts.None && !control.isInitialized)
    control.AfterInitialize();
  });
  ASPx.RippleHelper.Init();
 },
 DoFinalizeCallback: function() {
  this.ForEachControl(function(control){
   control.DoFinalizeCallback();
  });
 },
 ProcessControlsInContainer: function(container, processFunc) {
  this.ForEachControl(function(control){
   if(!container || this.IsControlInContainer(container, control))
    processFunc(control);
  });
 },
 IsControlInContainer: function(container, control) {
  if(control.GetMainElement) {
   var mainElement = control.GetMainElement();
   if(mainElement && (mainElement != container)) {
    if(ASPx.GetIsParent(container, mainElement))
     return true;
   }
  }
  return false;
 },
 RaiseControlsInitialized: function(isCallback) {
  if(typeof(isCallback) == "undefined")
   isCallback = true;
  var args = new ASPxClientControlsInitializedEventArgs(isCallback);
  if(!this.ControlsInitialized.IsEmpty())  
   this.ControlsInitialized.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalControlsInitialized(args);
  });
 },
 RaiseBrowserWindowResized: function() {
  var args = new ASPxClientEventArgs();
  if(!this.BrowserWindowResized.IsEmpty())
   this.BrowserWindowResized.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalBrowserWindowResized(args);
  });
 },
 RaiseBeginCallback: function (control, command) {
  var args = new ASPxClientGlobalBeginCallbackEventArgs(control, command);
  if(!this.BeginCallback.IsEmpty())
   this.BeginCallback.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalBeginCallback(args);
  });
  this.IncrementRequestCount();
 },
 RaiseEndCallback: function (control) {
  var args = new ASPxClientGlobalEndCallbackEventArgs(control);
  if (!this.EndCallback.IsEmpty()) 
   this.EndCallback.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalEndCallback(args);
  });
  this.DecrementRequestCount();
 },
 InCallback: function() {
  return this.requestCountInternal > 0;
 },
 RaiseCallbackError: function (control, message, callbackId) {
  var args = new ASPxClientGlobalCallbackErrorEventArgs(control, message, callbackId);
  if (!this.CallbackError.IsEmpty()) 
   this.CallbackError.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalCallbackError(args);
  });
  if(args.handled)
   return { isHandled: true, errorMessage: args.message };  
  return { isHandled: false, errorMessage: message };
 },
 RaiseValidationCompleted: function (container, validationGroup, invisibleControlsValidated, isValid, firstInvalidControl, firstVisibleInvalidControl) {
  var args = new ASPxClientValidationCompletedEventArgs(container, validationGroup, invisibleControlsValidated, isValid, firstInvalidControl, firstVisibleInvalidControl);
  if (!this.ValidationCompleted.IsEmpty()) 
   this.ValidationCompleted.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalValidationCompleted(args);
  });
 },
 Before_WebForm_InitCallback: function(callbackOwnerID){
  var args = new BeforeInitCallbackEventArgs(callbackOwnerID);
  this.BeforeInitCallback.FireEvent(this, args);
 },
 InitWindowSizeCache: function(){
  this.prevWndWidth = ASPx.GetDocumentClientWidth();
  this.prevWndHeight = ASPx.GetDocumentClientHeight();
 },
 OnBrowserWindowResize: function(evt){
  var shouldIgnoreNestedEvents = ASPx.Browser.IE && ASPx.Browser.MajorVersion == 8;
  if(shouldIgnoreNestedEvents) {
   if(this.prevWndWidth === "" || this.prevWndHeight === "" || this.browserWindowResizeLocked)
    return;
   this.browserWindowResizeLocked = true;
  }
  this.OnBrowserWindowResizeCore(evt);
  if(shouldIgnoreNestedEvents)
   this.browserWindowResizeLocked = false;
 },
 OnBrowserWindowResizeCore: function(htmlEvent){
  var args = this.CreateOnBrowserWindowResizeEventArgs(htmlEvent);
  if(this.CalculateIsBrowserWindowSizeChanged()) {
   this.forEachControlHierarchy(null, this, true, function(control) {
    if(control.IsDOMInitialized())
     control.OnBrowserWindowResizeInternal(args);
   });
   this.RaiseBrowserWindowResized();
  }
 },
 CreateOnBrowserWindowResizeEventArgs: function(htmlEvent){
  return {
   htmlEvent: htmlEvent,
   wndWidth: ASPx.GetDocumentClientWidth(),
   wndHeight: ASPx.GetDocumentClientHeight(),
   prevWndWidth: this.prevWndWidth,
   prevWndHeight: this.prevWndHeight
  }
 },
 CalculateIsBrowserWindowSizeChanged: function(){
  var wndWidth = ASPx.GetDocumentClientWidth();
  var wndHeight = ASPx.GetDocumentClientHeight();
  var isBrowserWindowSizeChanged = (this.prevWndWidth != wndWidth) || (this.prevWndHeight != wndHeight);
  if(isBrowserWindowSizeChanged){
   this.prevWndWidth = wndWidth;
   this.prevWndHeight = wndHeight;
   return true;
  }
  return false;
 },
 OnPost: function(args){
  this.ForEachControl(function(control) {
   control.OnPost(args);
  }, null);
 },
 OnPostFinalization: function(args){
  this.ForEachControl(function(control) {
   control.OnPostFinalization(args);
  }, null);
 },
 IncrementRequestCount: function() {
  this.requestCountInternal++;
 },
 DecrementRequestCount: function() {
  this.requestCountInternal--;
 },
 ResetRequestCount: function() {
  this.requestCountInternal = 0;
 }
});
ASPxClientControlCollection.BaseCollectionType = "Control";
var controlCollection = null;
function aspxGetControlCollection(){
 if(controlCollection == null) 
  controlCollection = new ASPxClientControlCollection();
 return controlCollection;
}
var ControlCollectionCollection = ASPx.CreateClass(ASPx.CollectionBase, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
 },
 Add: function(element) {
  var key = element.GetCollectionType();
  if(!key) throw "The collection type isn't specified.";
  if(this.Get(key)) throw "The collection with type='" + key + "' already exists.";
  ASPx.CollectionBase.prototype.Add.call(this, key, element);
 },
 RemoveDisposedControls: function(){
  var baseCollection = this.Get(ASPxClientControlCollection.BaseCollectionType);
  var disposedControls = [];
  baseCollection.elementsMap.forEachEntry(function(name, control) {
   if(!ASPx.Ident.IsASPxClientControl(control)) return;
   if(control.IsDOMDisposed())
    disposedControls.push(control);
  });
  for(var i = 0; i < disposedControls.length; i++) {
   this.elementsMap.forEachEntry(function(key, collection) {
    if(ASPx.Ident.IsASPxClientCollection(collection))
     collection.Remove(disposedControls[i]);
   });
  }
 }
});
var controlCollectionCollection = null;
function aspxGetControlCollectionCollection(){
 if(controlCollectionCollection == null)
  controlCollectionCollection = new ControlCollectionCollection();
 return controlCollectionCollection;
}
var AriaDescriptionAttributes = {
 Role: "0",
 AriaLabel: "1",
 TabIndex: "2",
 AriaOwns: "3",
 AriaDescribedBy: "4",
 AriaDisabled: "5",
 AriaHasPopup: "6",
 AriaLevel: "7"
};
var AriaDescriptor = ASPx.CreateClass(null, {
 constructor: function(ownerControl, description) {
  this.ownerControl = ownerControl;
  this.rootElement = ownerControl.GetMainElement();
  this.description = description;
 },
 setDescription: function(name, argList) {
  var description = this.findChildDescription(name);
  if(description) {
   var elements = name ? this.rootElement.querySelectorAll(this.getDescriptionSelector(description)) : [this.rootElement];
   for(var i = 0; i < elements.length; i++)
    this.applyDescriptionToElement(elements[i], description, argList[i] || argList[0]);
  }
 },
 getDescriptionName: function(description) {
  return description.n;
 },
 getDescriptionSelector: function(description) {
  return description.s;
 },
 findChildDescription: function(name) {
  if(name === this.getDescriptionName(this.description))
   return this.description;
  var childCollection = this.description.c || [];
  for(var i = 0; i < childCollection.length; i++) {
   var childDescription = childCollection[i];
   if(this.getDescriptionName(childDescription) === name)
    return childDescription;
  }
  return null;
 },
 applyDescriptionToElement: function(element, description, args) {
  if(!description || !element)
   return;
  this.trySetAriaOwnsAttribute(element, description);
  this.trySetAriaDescribedByAttribute(element, description);
  this.trySetAttribute(element, description, AriaDescriptionAttributes.Role, "role");
  this.trySetAttribute(element, description, AriaDescriptionAttributes.TabIndex, "tabindex");
  this.trySetAttribute(element, description, AriaDescriptionAttributes.AriaLevel, "aria-level");
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaLabel, function(value) {
   ASPx.Attr.SetAttribute(element, "aria-label", ASPx.Str.ApplyReplacement(value, args));
  });
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaDisabled, function(value) {
   ASPx.Attr.SetAttribute(element, "aria-disabled", !!value); 
  });
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaHasPopup, function(value) {
   ASPx.Attr.SetAttribute(element, "aria-haspopup", !!value);
  });
 },
 trySetAriaDescribedByAttribute: function(element, description) {
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaDescribedBy, function(selectorInfo) {
   var descriptor = this.getNodesBySelector(element, selectorInfo.descriptorSelector)[0];
   var target = this.getNodesBySelector(element, selectorInfo.targetSelector)[0];
   if(!target || !descriptor)
    return;
   ASPx.Attr.SetAttribute(target, "aria-describedby", this.getNodeId(descriptor));
  });
 },
 trySetAriaOwnsAttribute: function(element, description) {
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaOwns, function(selector) {
   var ownedNodes = this.getNodesBySelector(element, selector);
   var ariaOwnsAttributeValue = "";
   for(var i = 0; i < ownedNodes.length; i++)
    ariaOwnsAttributeValue += (this.getNodeId(ownedNodes[i]) + (i != ownedNodes.length - 1 ? " " : ""));
   ASPx.Attr.SetAttribute(element, "aria-owns", ariaOwnsAttributeValue);
  });
 },
 trySetAttribute: function(element, description, ariaAttribute, attributeName) {
  this.executeOnDescription(description, ariaAttribute, function(value) { 
   ASPx.Attr.SetAttribute(element, attributeName, description[ariaAttribute]); 
  });
 },
 executeOnDescription: function(description, ariaDescAttr, callback) {
  var descInfo = description[ariaDescAttr];
  if(ASPx.IsExists(descInfo))
   callback.aspxBind(this)(descInfo);
 },
 getNodesBySelector: function(element, selector) {
  var id = element.id || "";
  var childNodes = element.querySelectorAll("#" + this.getNodeId(element) + " > " + selector);
  ASPx.Attr.SetOrRemoveAttribute(element, "id", id);
  return childNodes;
 },
 getNodeId: function(node) {
  if(!node.id)
   node.id = this.createRandomId();
  return node.id; 
 },
 createRandomId: function() {
  return "r" + ASPx.CreateGuid();
 }
});
PagerCommands = {
 Next : "PBN",
 Prev : "PBP",
 Last : "PBL",
 First : "PBF",
 PageNumber : "PN",
 PageSize : "PSP"
};
ASPx.Callback = function(result, context){
 var collection = aspxGetControlCollection();
 collection.DoFinalizeCallback();
 var control = collection.Get(context);
 if(control != null)
  control.DoCallback(result);
 ASPx.RippleHelper.ReInit();
}
ASPx.CallbackError = function(result, context){
 var control = aspxGetControlCollection().Get(context);
 if(control != null)
  control.DoCallbackError(result, false);
}
ASPx.CClick = function(name, evt) {
 var control = aspxGetControlCollection().Get(name);
 if(control != null) control.DoControlClick(evt);
}
function aspxCAInit() {
 var isAppInit = typeof(Sys$_Application$initialize) != "undefined" &&
  ASPx.FunctionIsInCallstack(arguments.callee, Sys$_Application$initialize, 10 );
 aspxGetControlCollection().AtlasInitialize(!isAppInit);
}
ASPx.Evt.AttachEventToElement(window, "resize", aspxGlobalWindowResize);
function aspxGlobalWindowResize(evt){
 aspxGetControlCollection().OnBrowserWindowResize(evt); 
}
ASPx.Evt.AttachEventToElement(window.document, "DOMContentLoaded", aspxClassesDOMContentLoaded);
function aspxClassesDOMContentLoaded(evt){
 aspxGetControlCollection().DOMContentLoaded();
}
ASPx.GetControlCollection = aspxGetControlCollection;
ASPx.GetControlCollectionCollection = aspxGetControlCollectionCollection;
ASPx.GetPersistentControlPropertiesStorage = _aspxGetPersistentControlPropertiesStorage;
ASPx.PagerCommands = PagerCommands;
window.ASPxClientBeginCallbackEventArgs = ASPxClientBeginCallbackEventArgs;
window.ASPxClientGlobalBeginCallbackEventArgs = ASPxClientGlobalBeginCallbackEventArgs;
window.ASPxClientEndCallbackEventArgs = ASPxClientEndCallbackEventArgs;
window.ASPxClientGlobalEndCallbackEventArgs = ASPxClientGlobalEndCallbackEventArgs;
window.ASPxClientCallbackErrorEventArgs = ASPxClientCallbackErrorEventArgs;
window.ASPxClientGlobalCallbackErrorEventArgs = ASPxClientGlobalCallbackErrorEventArgs;
window.ASPxClientCustomDataCallbackEventArgs = ASPxClientCustomDataCallbackEventArgs;
window.ASPxClientValidationCompletedEventArgs = ASPxClientValidationCompletedEventArgs;
window.ASPxClientControlsInitializedEventArgs = ASPxClientControlsInitializedEventArgs;
window.ASPxClientControlBeforePronounceEventArgs = ASPxClientControlBeforePronounceEventArgs;
window.ASPxClientControlCollection = ASPxClientControlCollection;
window.ASPxClientControlBase = ASPxClientControlBase;
window.ASPxClientControl = ASPxClientControl;
window.ASPxClientComponent = ASPxClientComponent;
})();
(function () {
 var PositionAnimationTransition = ASPx.CreateClass(ASPx.AnimationTransitionBase, {
  constructor: function (element, options) {
   this.constructor.prototype.constructor.call(this, element, options);
   this.direction = options.direction;
   this.animationTransition = this.createAnimationTransition();
   AnimationHelper.appendWKAnimationClassNameIfRequired(this.element);
  },
  Start: function (to) {
   var from = this.GetValue();
   if(ASPx.AnimationUtils.CanUseCssTransform()) {
    from = this.convertPosToCssTransformPos(from);
    to = this.convertPosToCssTransformPos(to);
   }
   this.animationTransition.Start(from, to);
  },
  SetValue: function (value) {
   ASPx.AnimationUtils.SetTransformValue(this.element, value, this.direction == AnimationHelper.SLIDE_VERTICAL_DIRECTION);
  },
  GetValue: function () {
   return ASPx.AnimationUtils.GetTransformValue(this.element, this.direction == AnimationHelper.SLIDE_VERTICAL_DIRECTION);
  },
  createAnimationTransition: function () {
   var transition = ASPx.AnimationUtils.CanUseCssTransform() ? this.createTransformAnimationTransition() : this.createPositionAnimationTransition();
   transition.transition = ASPx.AnimationConstants.Transitions.POW_EASE_OUT;
   return transition;
  },
  createTransformAnimationTransition: function () {
   return ASPx.AnimationUtils.createCssAnimationTransition(this.element, {
    property: ASPx.AnimationUtils.CanUseCssTransform(),
    duration: this.duration,
    onComplete: this.onComplete
   });
  },
  createPositionAnimationTransition: function () {
   return AnimationHelper.createAnimationTransition(this.element, {
    property: this.direction == AnimationHelper.SLIDE_VERTICAL_DIRECTION ? "top" : "left",
    unit: "px",
    duration: this.duration,
    onComplete: this.onComplete
   });
  },
  convertPosToCssTransformPos: function (position) {
   return ASPx.AnimationUtils.GetTransformCssText(position, this.direction == AnimationHelper.SLIDE_VERTICAL_DIRECTION);
  }
 });
 var AnimationHelper = {
  SLIDE_HORIZONTAL_DIRECTION: 0,
  SLIDE_VERTICAL_DIRECTION: 1,
  SLIDE_TOP_DIRECTION: 0,
  SLIDE_RIGHT_DIRECTION: 1,
  SLIDE_BOTTOM_DIRECTION: 2,
  SLIDE_LEFT_DIRECTION: 3,
  SLIDE_CONTAINER_CLASS: "dxAC",
  MAXIMUM_DEPTH: 3,
  createAnimationTransition: function (element, options) {
   if(options.onStep) 
    options.animationEngine = "js";
   switch (options.animationEngine) {
    case "js":
     return ASPx.AnimationUtils.createJsAnimationTransition(element, options);
    case "css":
     return ASPx.AnimationUtils.createCssAnimationTransition(element, options);
    default:
     return ASPx.AnimationUtils.CanUseCssTransition() ? ASPx.AnimationUtils.createCssAnimationTransition(element, options) :
      ASPx.AnimationUtils.createJsAnimationTransition(element, options);
   }
  },
  createMultipleAnimationTransition: function (element, options) {
   return ASPx.AnimationUtils.createMultipleAnimationTransition(element, options);
  },
  createSimpleAnimationTransition: function (options) {
   return ASPx.AnimationUtils.createSimpleAnimationTransition(options);
  },
  cancelAnimation: function (element) {
   ASPx.AnimationTransitionBase.Cancel(element);
  },
  fadeIn: function (element, onComplete, duration) {
   AnimationHelper.fadeTo(element, {
    from: 0, to: 1,
    onComplete: onComplete,
    duration: duration || ASPx.AnimationConstants.Durations.DEFAULT
   });
  },
  fadeOut: function (element, onComplete, duration) {
   AnimationHelper.fadeTo(element, {
    from: ASPx.GetElementOpacity(element), to: 0,
    onComplete: onComplete,
    duration: duration || ASPx.AnimationConstants.Durations.DEFAULT
   });
  },
  fadeTo: function (element, options) {
   options.property = "opacity";
   if(!options.duration)
    options.duration = ASPx.AnimationConstants.Durations.SHORT;
   var transition = AnimationHelper.createAnimationTransition(element, options);
   if(!ASPx.IsExists(options.from))
    options.from = transition.GetValue();
   transition.Start(options.from, options.to);
  },
  slideIn: function (element, direction, onComplete, animationEngineType) {
   AnimationHelper.setOpacity(element, 1);
   var animationContainer = AnimationHelper.getSlideAnimationContainer(element, true, true);
   var pos = AnimationHelper.getSlideInStartPos(animationContainer, direction);
   var transition = AnimationHelper.createSlideTransition(animationContainer, direction,
    function (el) {
     AnimationHelper.resetSlideAnimationContainerSize(animationContainer);
     if(onComplete)
      onComplete(el);
    }, animationEngineType);
   transition.Start(pos, 0);
  },
  slideOut: function (element, direction, onComplete, animationEngineType) {
   var animationContainer = AnimationHelper.getSlideAnimationContainer(element, true, true);
   var pos = AnimationHelper.getSlideOutFinishPos(animationContainer, direction);
   var transition = AnimationHelper.createSlideTransition(animationContainer, direction,
    function (el) {
     AnimationHelper.setOpacity(el.firstChild, 0);
     if(onComplete)
      onComplete(el);
    }, animationEngineType);
   transition.Start(pos);
  },
  slideTo: function (element, options) {
   if(!ASPx.IsExists(options.direction))
    options.direction = AnimationHelper.SLIDE_HORIZONTAL_DIRECTION;
   var transition = new PositionAnimationTransition(element, options);
   transition.Start(options.to);
  },
  setOpacity: function (element, value) {
   ASPx.AnimationUtils.setOpacity(element, value);
  },
  appendWKAnimationClassNameIfRequired: function (element) {
   if(ASPx.AnimationUtils.CanUseCssTransform() && ASPx.Browser.WebKitFamily && !ASPx.ElementHasCssClass(element, "dx-wbv"))
    element.className += " dx-wbv";
  },
  findSlideAnimationContainer: function (element) {
   var container = element
   for(var i = 0; i < AnimationHelper.MAXIMUM_DEPTH; i++) {
    if(container.tagName == "BODY")
     return null;
    if(ASPx.ElementHasCssClass(container, AnimationHelper.SLIDE_CONTAINER_CLASS))
     return container;
    container = container.parentNode;
   }
   return null;
  },
  createSlideAnimationContainer: function (element) {
   var rootContainer = document.createElement("DIV");
   ASPx.SetStyles(rootContainer, {
    className: AnimationHelper.SLIDE_CONTAINER_CLASS,
    overflow: "hidden"
   });
   var elementContainer = document.createElement("DIV");
   rootContainer.appendChild(elementContainer);
   var parentNode = element.parentNode;
   parentNode.insertBefore(rootContainer, element);
   elementContainer.appendChild(element);
   return rootContainer;
  },
  getSlideAnimationContainer: function (element, create, fixSize) {
   if(!element) return;
   var width = element.offsetWidth;
   var height = element.offsetHeight;
   var container;
   if(element.className == AnimationHelper.SLIDE_CONTAINER_CLASS)
    container = element;
   if(!container)
    container = AnimationHelper.findSlideAnimationContainer(element);
   if(!container && create)
    container = AnimationHelper.createSlideAnimationContainer(element);
   if(container && fixSize) {
    ASPx.SetStyles(container, {
     width: width, height: height
    });
    ASPx.SetStyles(container.firstChild, {
     width: width, height: height
    });
   }
   return container;
  },
  resetSlideAnimationContainerSize: function (container) {
   ASPx.SetStyles(container, {
    width: "", height: ""
   });
   ASPx.SetStyles(container.firstChild, {
    width: "", height: ""
   });
  },
  getModifyProperty: function (direction) {
   if(direction == AnimationHelper.SLIDE_TOP_DIRECTION || direction == AnimationHelper.SLIDE_BOTTOM_DIRECTION)
    return "marginTop";
   return "marginLeft";
  },
  createSlideTransition: function (animationContainer, direction, complete, animationEngineType) {
   var animationEngine = "";
   switch(animationEngineType) {
    case AnimationEngineType.JS:
     animationEngine = "js";
     break;
    case AnimationEngineType.CSS:
     animationEngine = "css";
     break;
   }
   return AnimationHelper.createAnimationTransition(animationContainer.firstChild, {
    unit: "px",
    property: AnimationHelper.getModifyProperty(direction),
    onComplete: complete,
    animationEngine: animationEngine
   });
  },
  getSlideInStartPos: function (animationContainer, direction) {
   switch (direction) {
    case AnimationHelper.SLIDE_TOP_DIRECTION:
     return animationContainer.offsetHeight;
    case AnimationHelper.SLIDE_LEFT_DIRECTION:
     return animationContainer.offsetWidth;
    case AnimationHelper.SLIDE_RIGHT_DIRECTION:
     return -animationContainer.offsetWidth;
    case AnimationHelper.SLIDE_BOTTOM_DIRECTION:
     return -animationContainer.offsetHeight;
   }
  },
  getSlideOutFinishPos: function (animationContainer, direction) {
   switch (direction) {
    case AnimationHelper.SLIDE_TOP_DIRECTION:
     return -animationContainer.offsetHeight;
    case AnimationHelper.SLIDE_LEFT_DIRECTION:
     return -animationContainer.offsetWidth;
    case AnimationHelper.SLIDE_RIGHT_DIRECTION:
     return animationContainer.offsetWidth;
    case AnimationHelper.SLIDE_BOTTOM_DIRECTION:
     return animationContainer.offsetHeight;
   }
  }
 };
 var GestureHandler = ASPx.CreateClass(null, {
  constructor: function (getAnimationElement, canHandle, allowStart) {
   this.getAnimationElement = getAnimationElement;
   this.canHandle = canHandle;
   this.allowStart = allowStart;
   this.startMousePosX = 0;
   this.startMousePosY = 0;
   this.startTime = null;
   this.isEventsPrevented = false;
   this.savedElements = [];
  },
  OnSelectStart: function(evt) {
   ASPx.Evt.PreventEvent(evt); 
  },
  OnDragStart: function(evt) {
   ASPx.Evt.PreventEvent(evt);  
  },
  OnMouseDown: function (evt) {
   this.startMousePosX = ASPx.Evt.GetEventX(evt);
   this.startMousePosY = ASPx.Evt.GetEventY(evt);
   this.startTime = new Date();
  },
  OnMouseMove: function(evt) {
   if(!ASPx.Browser.MobileUI)
    ASPx.Selection.Clear();
   if(Math.abs(this.GetCurrentDistanceX(evt)) < GestureHandler.SLIDER_MIN_START_DISTANCE && Math.abs(this.GetCurrentDistanceY(evt)) < GestureHandler.SLIDER_MIN_START_DISTANCE)
    GesturesHelper.isExecutedGesture = false;
  },
  OnMouseUp: function (evt) {
  },
  CanHandleEvent: function (evt) {
   return !this.canHandle || this.canHandle(evt);
  },
  IsStartAllowed: function(value) {
   return !this.allowStart || this.allowStart(value);
  },
  RollbackGesture: function () {
  },
  GetRubberPosition: function (position) {
   return position / GestureHandler.FACTOR_RUBBER;
  },
  GetCurrentDistanceX: function (evt) {
   return ASPx.Evt.GetEventX(evt) - this.startMousePosX;
  },
  GetCurrentDistanceY: function (evt) {
   return ASPx.Evt.GetEventY(evt) - this.startMousePosY;
  },
  GetDistanceLimit: function () {
   return (new Date() - this.startTime) < GestureHandler.MAX_TIME_SPAN ? GestureHandler.MIN_DISTANCE_LIMIT : GestureHandler.MAX_DISTANCE_LIMIT;
  },
  GetContainerElement: function () {
  },
  AttachPreventEvents: function (evt) {
   if(!this.isEventsPrevented) {
    var element = ASPx.Evt.GetEventSource(evt);
    var container = this.GetContainerElement();
    while(element && element != container) {
     ASPx.Evt.AttachEventToElement(element, "mouseup", ASPx.Evt.PreventEvent);
     ASPx.Evt.AttachEventToElement(element, "click", ASPx.Evt.PreventEvent);
     this.savedElements.push(element);
     element = element.parentNode;
    }
    this.isEventsPrevented = true;
   }
  },
  DetachPreventEvents: function () {
   if(this.isEventsPrevented) {
    window.setTimeout(function () {
     while(this.savedElements.length > 0) {
      var element = this.savedElements.pop();
      ASPx.Evt.DetachEventFromElement(element, "mouseup", ASPx.Evt.PreventEvent);
      ASPx.Evt.DetachEventFromElement(element, "click", ASPx.Evt.PreventEvent);
     }
    }.aspxBind(this), 0);
    this.isEventsPrevented = false;
   }
  }
 });
 GestureHandler.MAX_DISTANCE_LIMIT = 70;
 GestureHandler.MIN_DISTANCE_LIMIT = 10;
 GestureHandler.MIN_START_DISTANCE = 0;
 GestureHandler.SLIDER_MIN_START_DISTANCE = 5;
 GestureHandler.MAX_TIME_SPAN = 300;
 GestureHandler.FACTOR_RUBBER = 4;
 GestureHandler.RETURN_ANIMATION_DURATION = 150;
 var SwipeSlideGestureHandler = ASPx.CreateClass(GestureHandler, {
  constructor: function (getAnimationElement, direction, canHandle, backward, forward, rollback, move) {
   this.constructor.prototype.constructor.call(this, getAnimationElement, canHandle);
   this.slideElement = this.getAnimationElement();
   this.container = this.slideElement.parentNode;
   this.direction = direction;
   this.backward = backward;
   this.forward = forward;
   this.rollback = rollback;
   this.slideElementSize = 0;
   this.containerElementSize = 0;
   this.startSliderElementPosition = 0;
   this.centeredSlideElementPosition = 0;
  },
  OnMouseDown: function (evt) {
   GestureHandler.prototype.OnMouseDown.call(this, evt);
   this.slideElementSize = this.GetElementSize();
   this.startSliderElementPosition = this.GetElementPosition();
   this.containerElementSize = this.GetContainerElementSize();
   if(this.slideElementSize <= this.containerElementSize)
    this.centeredSlideElementPosition = (this.containerElementSize - this.slideElementSize) / 2;
  },
  OnMouseMove: function (evt) {
   GestureHandler.prototype.OnMouseMove.call(this, evt);
   if(!ASPx.Browser.TouchUI && !ASPx.GetIsParent(this.container, ASPx.Evt.GetEventSource(evt))) {
    GesturesHelper.OnDocumentMouseUp(evt);
    return;
   }
   var distance = this.GetCurrentDistance(evt);
   if(Math.abs(distance) < GestureHandler.SLIDER_MIN_START_DISTANCE || ASPx.TouchUIHelper.isGesture)
    return;
   this.SetElementPosition(this.GetCalculatedPosition(distance));
   this.AttachPreventEvents(evt);
   ASPx.Evt.PreventEvent(evt);
  },
  GetCalculatedPosition: function (distance) {
   ASPx.AnimationTransitionBase.Cancel(this.slideElement);
   var position = this.startSliderElementPosition + distance,
    maxPosition = -(this.slideElementSize - this.containerElementSize),
    minPosition = 0;
   if(this.centeredSlideElementPosition > 0)
    position = this.GetRubberPosition(distance) + this.centeredSlideElementPosition;
   else if(position > minPosition)
    position = this.GetRubberPosition(distance);
   else if(position < maxPosition)
    position = this.GetRubberPosition(distance) + maxPosition;
   return position;
  },
  OnMouseUp: function (evt) {
   this.DetachPreventEvents();
   if(this.GetCurrentDistance(evt) != 0)
    this.OnMouseUpCore(evt);
  },
  OnMouseUpCore: function (evt) {
   var distance = this.GetCurrentDistance(evt);
   if(this.centeredSlideElementPosition > 0 || this.CheckSlidePanelIsOutOfBounds())
    this.PerformRollback();
   else
    this.PerformAction(distance);
  },
  PerformAction: function (distance) {
   if(Math.abs(distance) < this.GetDistanceLimit())
    this.PerformRollback();
   else if(distance < 0)
    this.PerformForward();
   else
    this.PerformBackward();
  },
  PerformBackward: function () {
   this.backward();
  },
  PerformForward: function () {
   this.forward();
  },
  PerformRollback: function () {
   this.rollback();
  },
  CheckSlidePanelIsOutOfBounds: function () {
   var minOffset = -(this.slideElementSize - this.containerElementSize), maxOffset = 0;
   var position = null, slideElementPos = this.GetElementPosition();
   if(slideElementPos > maxOffset || slideElementPos < minOffset)
    return true;
   return false;
  },
  GetContainerElement: function () {
   return this.container;
  },
  GetElementSize: function () {
   return this.IsHorizontalDirection() ? this.slideElement.offsetWidth : this.slideElement.offsetHeight;
  },
  GetContainerElementSize: function () {
   return this.IsHorizontalDirection() ? ASPx.GetClearClientWidth(this.container) : ASPx.GetClearClientHeight(this.container);
  },
  GetCurrentDistance: function (evt) {
   return this.IsHorizontalDirection() ? this.GetCurrentDistanceX(evt) : this.GetCurrentDistanceY(evt);
  },
  GetElementPosition: function () {
   return ASPx.AnimationUtils.GetTransformValue(this.slideElement, !this.IsHorizontalDirection());
  },
  SetElementPosition: function (position) {
   ASPx.AnimationUtils.SetTransformValue(this.slideElement, position, !this.IsHorizontalDirection());
  },
  IsHorizontalDirection: function () {
   return this.direction == AnimationHelper.SLIDE_HORIZONTAL_DIRECTION;
  }
 });
 var SwipeSimpleSlideGestureHandler = ASPx.CreateClass(SwipeSlideGestureHandler, {
  constructor: function (getAnimationElement, direction, canHandle, backward, forward, rollback, updatePosition) {
   this.constructor.prototype.constructor.call(this, getAnimationElement, direction, canHandle, backward, forward, rollback);
   this.container = this.slideElement;
   this.updatePosition = updatePosition;
   this.prevDistance = 0;
  },
  OnMouseDown: function (evt) {
   GestureHandler.prototype.OnMouseDown.call(this, evt);
   this.prevDistance = 0;
  },
  OnMouseUpCore: function (evt) {
   this.PerformAction(this.GetCurrentDistance(evt));
  },
  PerformAction: function (distance) {
   if(Math.abs(distance) < this.GetDistanceLimit())
    this.PerformRollback();
   else if(distance < 0)
    this.PerformForward();
   else
    this.PerformBackward();
  },
  GetCalculatedPosition: function (distance) {
   var position = distance - this.prevDistance;
   this.prevDistance = distance;
   return position;
  },
  SetElementPosition: function (position) {
   this.updatePosition(position);
  }
 });
 var SwipeGestureHandler = ASPx.CreateClass(GestureHandler, {
  constructor: function (getAnimationElement, canHandle, allowStart, start, allowComplete, complete, cancel, animationEngineType) {
   this.constructor.prototype.constructor.call(this, getAnimationElement, canHandle, allowStart);
   this.start = start;
   this.allowComplete = allowComplete;
   this.complete = complete;
   this.cancel = cancel;
   this.animationTween = null;
   this.currentDistanceX = 0;
   this.currentDistanceY = 0;
   this.tryStartGesture = false;
   this.tryStartScrolling = false;
   this.animationEngineType = animationEngineType;
   this.UpdateAnimationContainer();
  },
  UpdateAnimationContainer: function () {
   this.animationContainer = AnimationHelper.getSlideAnimationContainer(this.getAnimationElement(), true, false);
  },
  CanHandleEvent: function (evt) {
   if(GestureHandler.prototype.CanHandleEvent.call(this, evt))
    return true;
   return this.animationTween && this.animationContainer && ASPx.GetIsParent(this.animationContainer, ASPx.Evt.GetEventSource(evt));
  },
  OnMouseDown: function (evt) {
   GestureHandler.prototype.OnMouseDown.call(this, evt);
   if(this.animationTween)
    this.animationTween.Cancel();
   this.currentDistanceX = 0;
   this.currentDistanceY = 0;
   this.tryStartGesture = false;
   this.tryStartScrolling = false;
  },
  OnMouseMove: function (evt) {
   GestureHandler.prototype.OnMouseMove.call(this, evt);
   var isZoomGestureConflict = evt.touches && evt.touches.length > 1;
   if (isZoomGestureConflict)
    return false;
   this.currentDistanceX = this.GetCurrentDistanceX(evt);
   this.currentDistanceY = this.GetCurrentDistanceY(evt);
   if(!this.animationTween && !this.tryStartScrolling && (Math.abs(this.currentDistanceX) >
    GestureHandler.MIN_START_DISTANCE || Math.abs(this.currentDistanceY) > GestureHandler.MIN_START_DISTANCE)) {
    if(Math.abs(this.currentDistanceY) < Math.abs(this.currentDistanceX)) {
     this.tryStartGesture = true;
     if(this.IsStartAllowed(this.currentDistanceX)) {
      this.animationContainer = AnimationHelper.getSlideAnimationContainer(this.getAnimationElement(), true, true);
      this.animationTween = AnimationHelper.createSlideTransition(this.animationContainer, AnimationHelper.SLIDE_LEFT_DIRECTION,
       function () {
        AnimationHelper.resetSlideAnimationContainerSize(this.animationContainer);
        this.animationContainer = null;
        this.animationTween = null;
       }.aspxBind(this), this.animationEngineType);
      this.PerformStart(this.currentDistanceX);
      this.AttachPreventEvents(evt);
     }
    }
    else
     this.tryStartScrolling = true;
   }
   if(this.animationTween) {
    if(this.allowComplete && !this.allowComplete(this.currentDistanceX))
     this.currentDistanceX = this.GetRubberPosition(this.currentDistanceX);
    this.animationTween.SetValue(this.currentDistanceX);
   }
   if(!this.tryStartScrolling && !ASPx.TouchUIHelper.isGesture && evt.touches && evt.touches.length < 2)
    ASPx.Evt.PreventEvent(evt);
  },
  OnMouseUp: function (evt) {
   if(!this.animationTween) {
    if(this.tryStartGesture)
     this.PerformCancel(this.currentDistanceX);
   }
   else {
    if(Math.abs(this.currentDistanceX) < this.GetDistanceLimit())
     this.RollbackGesture();
    else {
     if(this.IsCompleteAllowed(this.currentDistanceX)) {
      this.PerformComplete(this.currentDistanceX);
      this.animationContainer = null;
      this.animationTween = null;
     }
     else
      this.RollbackGesture();
    }
   }
   this.DetachPreventEvents();
   this.tryStartGesture = false;
   this.tryStartScrolling = false;
  },
  PerformStart: function (value) {
   if(this.start)
    this.start(value);
  },
  IsCompleteAllowed: function (value) {
   return !this.allowComplete || this.allowComplete(value);
  },
  PerformComplete: function (value) {
   if(this.complete)
    this.complete(value);
  },
  PerformCancel: function (value) {
   if(this.cancel)
    this.cancel(value);
  },
  RollbackGesture: function () {
   this.animationTween.Start(this.currentDistanceX, 0);
  },
  ResetGestureElementPosition: function () {
   if (this.currentDistanceX === 0) return;
   var container = AnimationHelper.getSlideAnimationContainer(this.getAnimationElement());
   var onComplete = function () {  AnimationHelper.resetSlideAnimationContainerSize(container);  };
   var animation = AnimationHelper.createSlideTransition(container, AnimationHelper.SLIDE_LEFT_DIRECTION, onComplete, this.animationEngineType);
   animation.Start(this.currentDistanceX, 0);
  },
  GetContainerElement: function () {
   return this.animationContainer;
  }
 });
 var GesturesHelper = {
  handlers: {},
  activeHandler: null,
  isAttachedEvents: false,
  isExecutedGesture: false,
  AddSwipeGestureHandler: function (id, getAnimationElement, canHandle, allowStart, start, allowComplete, complete, cancel, animationEngineType) {
   this.handlers[id] = new SwipeGestureHandler(getAnimationElement, canHandle, allowStart, start, allowComplete, complete, cancel, animationEngineType);
  },
  UpdateSwipeAnimationContainer: function (id) {
   if(this.handlers[id])
    this.handlers[id].UpdateAnimationContainer();
  },
  AddSwipeSlideGestureHandler: function (id, getAnimationElement, direction, canHandle, backward, forward, rollback, updatePosition) {
   if(updatePosition)
    this.handlers[id] = new SwipeSimpleSlideGestureHandler(getAnimationElement, direction, canHandle, backward, forward, rollback, updatePosition);
   else
    this.handlers[id] = new SwipeSlideGestureHandler(getAnimationElement, direction, canHandle, backward, forward, rollback);
  },
  getParentDXEditorWithSwipeGestures: function(element) {
     return ASPx.GetParent(element, function(parent) {
      var parentObj = ASPx.GetControlCollection().Get(parent.id);
      return parentObj && parentObj.supportGestures && parentObj.isSwipeGesturesEnabled();
   });
  },
  canHandleMouseDown: function(evt) {
   if(!ASPx.Evt.IsLeftButtonPressed(evt))
    return false;
   var element = ASPx.Evt.GetEventSource(evt);
   var dxFocusedEditor = ASPx.Ident.scripts.ASPxClientEdit && ASPx.GetFocusedEditor();
   if(dxFocusedEditor && dxFocusedEditor.IsEditorElement(element)) {
    var elementParentDXEditorWithSwipeGestures = GesturesHelper.getParentDXEditorWithSwipeGestures(element);
    if(!elementParentDXEditorWithSwipeGestures || !dxFocusedEditor.IsEditorElement(elementParentDXEditorWithSwipeGestures))
     return false;
   }
   var isTextEditor = element.tagName == "TEXTAREA" || element.tagName == "INPUT" && ASPx.Attr.GetAttribute(element, "type") == "text";
   if(isTextEditor && document.activeElement == element)
    return false;
   return true;  
  },
  OnDocumentDragStart: function(evt) {
   if(GesturesHelper.activeHandler)
    GesturesHelper.activeHandler.OnDragStart(evt);
  },
  OnDocumentSelectStart: function(evt) {
   if(GesturesHelper.activeHandler)
    GesturesHelper.activeHandler.OnSelectStart(evt);
  },
  OnDocumentMouseDown: function (evt) {
   if(!GesturesHelper.canHandleMouseDown(evt))
    return;
   GesturesHelper.activeHandler = GesturesHelper.FindHandler(evt);
   if(GesturesHelper.activeHandler)
    GesturesHelper.activeHandler.OnMouseDown(evt);
  },
  OnDocumentMouseMove: function (evt) {
   if(GesturesHelper.activeHandler) {
    GesturesHelper.isExecutedGesture = true;
    GesturesHelper.activeHandler.OnMouseMove(evt);
   }
  },
  OnDocumentMouseUp: function (evt) {
   if(GesturesHelper.activeHandler) {
    GesturesHelper.activeHandler.OnMouseUp(evt);
    GesturesHelper.activeHandler = null;
    window.setTimeout(function () { GesturesHelper.isExecutedGesture = false; }, 0);
   }
  },
  AttachEvents: function () {
   if(!GesturesHelper.isAttachedEvents) {
    GesturesHelper.Attach(ASPx.Evt.AttachEventToElement);
    GesturesHelper.isAttachedEvents = true;
   }
  },
  DetachEvents: function () {
   if(GesturesHelper.isAttachedEvents) {
    GesturesHelper.Attach(ASPx.Evt.DetachEventFromElement);
    GesturesHelper.isAttachedEvents = false;
   }
  },
  Attach: function (changeEventsMethod) {
   var doc = window.document;
   changeEventsMethod(doc, ASPx.TouchUIHelper.touchMouseDownEventName, GesturesHelper.OnDocumentMouseDown);
   changeEventsMethod(doc, ASPx.TouchUIHelper.touchMouseMoveEventName, GesturesHelper.OnDocumentMouseMove);
   changeEventsMethod(doc, ASPx.TouchUIHelper.touchMouseUpEventName, GesturesHelper.OnDocumentMouseUp);
   if(!ASPx.Browser.MobileUI) {
    changeEventsMethod(doc, "selectstart", GesturesHelper.OnDocumentSelectStart);
    changeEventsMethod(doc, "dragstart", GesturesHelper.OnDocumentDragStart);
   }
  },
  FindHandler: function (evt) {
   var handlers = [];
   for(var id in GesturesHelper.handlers) {
    var handler = GesturesHelper.handlers[id];
    if(handler.CanHandleEvent && handler.CanHandleEvent(evt))
     handlers.push(handler);
   }
   if(!handlers.length)
    return null;
   handlers.sort(function (a, b) {
    return ASPx.GetIsParent(a.getAnimationElement(), b.getAnimationElement()) ? 1 : -1;
   });
   return handlers[0];
  },
  IsExecutedGesture: function () {
   return GesturesHelper.isExecutedGesture;
  }
 };
 GesturesHelper.AttachEvents();
 var AnimationEngineType = {
  "JS": 0,
  "CSS": 1,
  "DEFAULT" : 2
 }
 ASPx.AnimationEngineType = AnimationEngineType;
 ASPx.AnimationHelper = AnimationHelper;
 ASPx.GesturesHelper = GesturesHelper;
})();
(function() {
var ASPxClientEditBase = ASPx.CreateClass(ASPxClientControl, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.EnabledChanged = new ASPxClientEvent();
  this.captionPosition = ASPx.Position.Left;
  this.showCaptionColon = true;
 },
 InlineInitialize: function(){
  ASPxClientControl.prototype.InlineInitialize.call(this);
  this.InitializeEnabled(); 
 },
 InitializeEnabled: function() {
  this.SetEnabledInternal(this.clientEnabled, true);
 },
 GetValue: function() {
  var element = this.GetMainElement();
  if(ASPx.IsExistsElement(element))
   return element.innerHTML;
  return "";
 },
 GetValueString: function(){
  var value = this.GetValue();
  return (value == null) ? null : value.toString();
 },
 SetValue: function(value) {
  if(value == null)
   value = "";
  var element = this.GetMainElement();
  if(ASPx.IsExistsElement(element))
   element.innerHTML = value;
 },
 GetEnabled: function(){
  return this.enabled && this.clientEnabled;
 },
 SetEnabled: function(enabled){
  if(this.clientEnabled != enabled) {
   var errorFrameRequiresUpdate = this.GetIsValid && !this.GetIsValid();
   if(errorFrameRequiresUpdate && !enabled)
    this.UpdateErrorFrameAndFocus(false , null , true );
   this.clientEnabled = enabled;
   this.SetEnabledInternal(enabled, false);
   if(errorFrameRequiresUpdate && enabled)
    this.UpdateErrorFrameAndFocus(false );
   this.RaiseEnabledChangedEvent();
  }
 },
 SetEnabledInternal: function(enabled, initialization){
  if(!this.enabled) return;
  if(!initialization || !enabled)
   this.ChangeEnabledStateItems(enabled);
  this.ChangeEnabledAttributes(enabled);
  if(ASPx.Browser.Chrome) {   
   var mainElement = this.GetMainElement();
   if(mainElement)
    mainElement.className = mainElement.className;
  } 
 },
 ChangeEnabledAttributes: function(enabled){
 },
 ChangeEnabledStateItems: function(enabled){
 },
 RaiseEnabledChangedEvent: function(){
  if(!this.EnabledChanged.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.EnabledChanged.FireEvent(this, args);
  }
 },
 GetDecodeValue: function (value) { 
  if(typeof (value) == "string" && value.length > 1)
   value = this.SimpleDecodeHtml(value);
  return value;
 },
 SimpleDecodeHtml: function (html) {
  return ASPx.Str.ApplyReplacement(html, [
   [/&lt;/g, '<'],
   [/&amp;/g, '&'],
   [/&quot;/g, '"'],
   [/&#39;/g, '\''],
   [/&#32;/g, ' ']
  ]);
 },
 GetCachedElementById: function(idSuffix) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.name + idSuffix);
 },
 GetCaptionCell: function() {
  return this.GetCachedElementById(EditElementSuffix.CaptionCell);
 },
 GetExternalTable: function() {
  return this.GetCachedElementById(EditElementSuffix.ExternalTable);
 },
 getCaptionRelatedCellCount: function() {
  if(!this.captionRelatedCellCount)
   this.captionRelatedCellCount = ASPx.GetNodesByClassName(this.GetExternalTable(), CaptionRelatedCellClassName).length;
  return this.captionRelatedCellCount;
 },
 addCssClassToCaptionRelatedCells: function() {
  if(this.captionPosition == ASPx.Position.Left || this.captionPosition == ASPx.Position.Right) {
   var captionRelatedCellsIndex = this.captionPosition == ASPx.Position.Left ? 0 : this.GetCaptionCell().cellIndex;
   for(var i = 0; i < this.GetExternalTable().rows.length; i++)
    ASPx.AddClassNameToElement(this.GetExternalTable().rows[i].cells[captionRelatedCellsIndex], CaptionRelatedCellClassName);
  }
  if(this.captionPosition == ASPx.Position.Top || this.captionPosition == ASPx.Position.Bottom)
   for(var i = 0; i < this.GetCaptionCell().parentNode.cells.length; i++)
    ASPx.AddClassNameToElement(this.GetCaptionCell().parentNode.cells[i], CaptionRelatedCellClassName);
 },
 GetCaption: function() {
  if(ASPx.IsExists(this.GetCaptionCell()))
   return this.getCaptionInternal();
  return "";
 },
 SetCaption: function(caption) {
  if(!ASPx.IsExists(this.GetCaptionCell()))
   return;
  if(this.getCaptionRelatedCellCount() == 0)
   this.addCssClassToCaptionRelatedCells();
  if(caption !== "")
   ASPx.RemoveClassNameFromElement(this.GetExternalTable(), ASPxEditExternalTableClassNames.TableWithEmptyCaptionClassName);
  else
   ASPx.AddClassNameToElement(this.GetExternalTable(), ASPxEditExternalTableClassNames.TableWithEmptyCaptionClassName);
  this.setCaptionInternal(caption);
 },
 getCaptionTextNode: function() {
  var captionElement = ASPx.GetNodesByPartialClassName(this.GetCaptionCell(), CaptionElementPartialClassName)[0];
  return ASPx.GetNormalizedTextNode(captionElement);
 },
 getCaptionInternal: function() {
  var captionText = this.getCaptionTextNode().nodeValue;
  if(captionText !== "" && captionText[captionText.length - 1] == ":")
   captionText = captionText.substring(0, captionText.length - 1);
  return captionText;
 },
 setCaptionInternal: function(caption) {
  caption = ASPx.Str.Trim(caption);
  var captionTextNode = this.getCaptionTextNode();
  if(this.showCaptionColon && caption[caption.length - 1] != ":" && caption !== "")
   caption += ":";
  captionTextNode.nodeValue = caption;
 }
});
var ValidationPattern = ASPx.CreateClass(null, {
 constructor: function(errorText) {
  this.errorText = errorText;
 }
});
var RequiredFieldValidationPattern = ASPx.CreateClass(ValidationPattern, {
 constructor: function(errorText) {
  this.constructor.prototype.constructor.call(this, errorText);
 },
 EvaluateIsValid: function(value) {
  return value != null && (value.constructor == Array || ASPx.Str.Trim(value.toString()) != "");
 }
});
var RegularExpressionValidationPattern = ASPx.CreateClass(ValidationPattern, {
 constructor: function(errorText, pattern) {
  this.constructor.prototype.constructor.call(this, errorText);
  this.pattern = pattern;
 },
 EvaluateIsValid: function(value) {
  if(value == null) 
   return true;
  var strValue = value.toString();
  if(ASPx.Str.Trim(strValue).length == 0)
   return true;
  var regEx = new RegExp(this.pattern);
  var matches = regEx.exec(strValue);
  return matches != null && strValue == matches[0];
 }
});
function _aspxIsEditorFocusable(inputElement) {
 return ASPx.IsFocusableCore(inputElement, function(container) {
  return container.getAttribute("errorFrame") == "errorFrame";
 });
}
var invalidEditorToBeFocused = null;
var ValidationType = {
 PersonalOnValueChanged: "ValueChanged",
 PersonalViaScript: "CalledViaScript",
 MassValidation: "MassValidation"
};
var ErrorFrameDisplay = {
 None: "None",
 Static: "Static",
 Dynamic: "Dynamic"
};
var EditElementSuffix = {
 ExternalTable: "_ET",
 ControlCell: "_CC",
 ErrorCell: "_EC",
 ErrorTextCell: "_ETC",
 ErrorImage: "_EI",
 CaptionCell: "_CapC",
 AccessibilityAdditionalTextRow: "_AHTR"
};
var ASPxEditExternalTableClassNames = {
 ValidStaticTableClassName: "dxeValidStEditorTable",
 ValidDynamicTableClassName: "dxeValidDynEditorTable",
 TableWithSeparateBordersClassName: "tableWithSeparateBorders",
 TableWithEmptyCaptionClassName: "tableWithEmptyCaption"
};
var CaptionRelatedCellClassName = "dxeCaptionRelatedCell";
var CaptionElementPartialClassName = "dxeCaption";
var AccessibilityAssistantID = "AcAs";
var ASPxClientEdit = ASPx.CreateClass(ASPxClientEditBase, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.isASPxClientEdit = true;
  this.inputElement = null;
  this.convertEmptyStringToNull = true;
  this.readOnly = false;
  this.focused = false;
  this.focusEventsLocked = false;
  this.receiveGlobalMouseWheel = true;
  this.styleDecoration = null;
  this.heightCorrectionRequired = false;
  this.customValidationEnabled = false;
  this.display = ErrorFrameDisplay.Static;
  this.initialErrorText = "";
  this.causesValidation = false;
  this.validateOnLeave = true;
  this.validationGroup = "";
  this.sendPostBackWithValidation = null;
  this.validationPatterns = [];
  this.setFocusOnError = false;
  this.errorDisplayMode = "it";
  this.errorText = "";
  this.isValid = true;
  this.errorImageIsAssigned = false;
  this.notifyValidationSummariesToAcceptNewError = false;
  this.isErrorFrameRequired = false;
  this.enterProcessed = false;
  this.keyDownHandlers = {};
  this.keyPressHandlers = {};
  this.keyUpHandlers = {};
  this.specialKeyboardHandlingUsed = false;
  this.onKeyDownHandler = null;
  this.onKeyPressHandler = null;
  this.onKeyUpHandler = null;
  this.onGotFocusHandler = null;
  this.onLostFocusHandler = null;
  this.GotFocus = new ASPxClientEvent();
  this.LostFocus = new ASPxClientEvent();
  this.Validation = new ASPxClientEvent();
  this.ValueChanged = new ASPxClientEvent();
  this.KeyDown = new ASPxClientEvent();
  this.KeyPress = new ASPxClientEvent();
  this.KeyUp = new ASPxClientEvent();
  this.eventHandlersInitialized = false;
  this.ariaExplanatoryTextManager = null;
 },
 InitializeProperties: function(properties){
  if(properties.decorationStyles){
   for(var i = 0; i < properties.decorationStyles.length; i++)
    this.AddDecorationStyle(properties.decorationStyles[i].key, 
     properties.decorationStyles[i].className, 
     properties.decorationStyles[i].cssText);
  }
 },
 Initialize: function() {
  this.initialErrorText = this.errorText;
  ASPxClientEditBase.prototype.Initialize.call(this);
  this.InitializeKeyHandlers();
  this.UpdateClientValidationState();
  this.UpdateValidationSummaries(null , true );
 },
 InlineInitialize: function() {
  ASPxClientEditBase.prototype.InlineInitialize.call(this);
  if(!this.eventHandlersInitialized)
   this.InitializeEvents();
  if(this.styleDecoration)
   this.styleDecoration.Update();
  var externalTable = this.GetExternalTable();
  if(externalTable && ASPx.IsPercentageSize(externalTable.style.width)) {
   this.width = "100%";
   this.GetMainElement().style.width = "100%";
   if(this.isErrorFrameRequired)
    externalTable.setAttribute("errorFrame", "errorFrame");
  }
  this.ariaExplanatoryTextManager = this.CreateAriaExplanatoryTextManager();
 }, 
 AfterInitialize: function() {
  this.ariaExplanatoryTextManager.SetCaptionAssociating();
  this.ariaExplanatoryTextManager.UpdateText();
  this.ariaExplanatoryTextManager.UpdateValidationState();
  ASPxClientEditBase.prototype.AfterInitialize.call(this);
 },
 InitializeEvents: function() {
 },
 InitSpecialKeyboardHandling: function(){
  var name = this.name;
  this.onKeyDownHandler = function(evt) { ASPx.KBSIKeyDown(name,evt); };
  this.onKeyPressHandler = function(evt) { ASPx.KBSIKeyPress(name, evt); };
  this.onKeyUpHandler = function(evt) { ASPx.KBSIKeyUp(name, evt); };
  this.onGotFocusHandler = function(evt) { ASPx.ESGotFocus(name); };
  this.onLostFocusHandler = function(evt) { ASPx.ESLostFocus(name); };
  this.specialKeyboardHandlingUsed = true;
  this.InitializeDelayedSpecialFocus();
 },
 InitializeKeyHandlers: function() {
 },
 AddKeyDownHandler: function(key, handler) {
  this.keyDownHandlers[key] = handler;
 },
 AddKeyPressHandler: function(key, handler) {
  this.keyPressHandlers[key] = handler;
 },
 ChangeSpecialInputEnabledAttributes: function(element, method, doNotChangeAutoComplete){
  if(!doNotChangeAutoComplete) 
   element.autocomplete = "off";
  if(this.onKeyDownHandler != null)
   method(element, "keydown", this.onKeyDownHandler);
  if(this.onKeyPressHandler != null)
   method(element, "keypress", this.onKeyPressHandler);
  if(this.onKeyUpHandler != null)
   method(element, "keyup", this.onKeyUpHandler);
  if(this.onGotFocusHandler != null)
   method(element, "focus", this.onGotFocusHandler);
  if(this.onLostFocusHandler != null)
   method(element, "blur", this.onLostFocusHandler);
 },
 CreateAriaExplanatoryTextManager: function() {
  if(this.accessibilityCompliant)
   return new EditAccessibilityExplanatoryTextManager(this);
  else 
   return new DisableAccessibilityExplanatoryTextManager(this);
 },
 UpdateClientValidationState: function() {
  if(!this.customValidationEnabled)
   return;
  var mainElement = this.GetMainElement();
  if(mainElement) {
   var validationState = !this.GetIsValid() ? ("-" + this.GetErrorText()) : "";
   this.UpdateStateObjectWithObject({ validationState: validationState });
  }
 },
 UpdateValidationSummaries: function(validationType, initializing) {
  if(ASPx.Ident.scripts.ASPxClientValidationSummary) {
   var summaryCollection = ASPx.GetClientValidationSummaryCollection();
   summaryCollection.OnEditorIsValidStateChanged(this, validationType, initializing && this.notifyValidationSummariesToAcceptNewError);
  }
 },
 FindInputElement: function(){
  return null;
 },
 GetInputElement: function(){
  if(!ASPx.IsExistsElement(this.inputElement))
   this.inputElement = this.FindInputElement();
  return this.inputElement;
 },
 GetFocusableInputElement: function() {
  return this.GetInputElement();
 },
 GetAccessibilityActiveElements: function() {
  return [this.GetInputElement()];
 },
 GetAccessibilityFirstActiveElement: function() {
  return this.accessibilityHelper ? 
    this.accessibilityHelper.getMainElement() : 
    this.GetAccessibilityActiveElements()[0];
 },
 GetAccessibilityAssistantElement: function() {
  return this.GetChildElement(AccessibilityAssistantID);
 },
 GetErrorImage: function() {
  return this.GetCachedElementById(EditElementSuffix.ErrorImage);
 },
 GetControlCell: function() {
  return this.GetCachedElementById(EditElementSuffix.ControlCell);
 },
 GetErrorCell: function() {
  return this.GetCachedElementById(EditElementSuffix.ErrorCell);
 },
 GetErrorTextCell: function() {
  return this.GetCachedElementById(this.errorImageIsAssigned ? EditElementSuffix.ErrorTextCell : EditElementSuffix.ErrorCell);
 },
 SetVisible: function (isVisible) {
  if(this.clientVisible == isVisible)
   return;
  var externalTable = this.GetExternalTable();
  if(externalTable) {
   ASPx.SetElementDisplay(externalTable, isVisible);
   if(this.customValidationEnabled) {
    var isValid = !isVisible ? true : void (0);
    this.UpdateErrorFrameAndFocus(false , true , isValid );
   }
  }
  ASPxClientControl.prototype.SetVisible.call(this, isVisible);
 },
 GetStateHiddenFieldName: function() {
  return this.uniqueID + "$State";
 },
 GetValueInputToValidate: function() {
  return this.GetInputElement();
 },
 IsVisible: function() {
  if(!this.clientVisible)
   return false;
  var element = this.GetMainElement();
  if(!element) 
   return false;
  while(element && element.tagName != "BODY") {
   if(element.getAttribute("errorFrame") != "errorFrame" && (!ASPx.GetElementVisibility(element) || !ASPx.GetElementDisplay(element)))
    return false;
   element = element.parentNode;
  }
  return true;
 },
 AdjustControlCore: function() {
  this.CollapseEditor();
  this.UnstretchInputElement();
  if(this.heightCorrectionRequired)
   this.CorrectEditorHeight();
 },
 CorrectEditorHeight: function() {
 },
 UnstretchInputElement: function() {
 },
 UseDelayedSpecialFocus: function() {
  return false;
 },
 GetDelayedSpecialFocusTriggers: function() {
  return [ this.GetMainElement() ];
 },
 InitializeDelayedSpecialFocus: function() {
  if(!this.UseDelayedSpecialFocus())
   return;
  this.specialFocusTimer = -1;    
  var handler = function(evt) { this.OnDelayedSpecialFocusMouseDown(evt); }.aspxBind(this);
  var triggers = this.GetDelayedSpecialFocusTriggers();
  for(var i = 0; i < triggers.length; i++)
   ASPx.Evt.AttachEventToElement(triggers[i], "mousedown", handler);
 },
 OnDelayedSpecialFocusMouseDown: function(evt) {
  window.setTimeout(function() { this.SetFocus(); }.aspxBind(this), 0);
 },
 IsFocusEventsLocked: function() {
  return this.focusEventsLocked;
 },
 LockFocusEvents: function() {
  if(!this.focused) return;
  this.focusEventsLocked = true;
 },
 UnlockFocusEvents: function() {
  this.focusEventsLocked = false;
 },
 ForceRefocusEditor: function(evt, isNativeFocus) {
  if(ASPx.Browser.VirtualKeyboardSupported) {
   var focusedEditor = ASPx.VirtualKeyboardUI.getFocusedEditor();
   if(ASPx.VirtualKeyboardUI.getInputNativeFocusLocked() && (!focusedEditor || focusedEditor === this))
     return;
   ASPx.VirtualKeyboardUI.setInputNativeFocusLocked(!isNativeFocus);
  }
  this.LockFocusEvents();
  this.BlurInputElement();
  window.setTimeout(function() { 
   if(ASPx.Browser.VirtualKeyboardSupported) {
    ASPx.VirtualKeyboardUI.setFocusEditorCore(this);
   } else {
    this.SetFocus();
   }
  }.aspxBind(this), 0);
 },
 BlurInputElement: function() {
  var inputElement = this.GetFocusableInputElement();
  if(inputElement && inputElement.blur)
   inputElement.blur();
 },
 IsEditorElement: function(element) {
  return this.GetMainElement() == element || ASPx.GetIsParent(this.GetMainElement(), element);
 },
 IsClearButtonElement: function(element) {
  return false;
 },
 IsElementBelongToInputElement: function(element) {
  return this.GetInputElement() == element;
 },
 OnFocusCore: function() {
  if(this.UseDelayedSpecialFocus())
   window.clearTimeout(this.specialFocusTimer);
  if(!this.IsFocusEventsLocked()){
   this.focused = true;
   ASPx.SetFocusedEditor(this);
   if(this.styleDecoration)
    this.styleDecoration.Update();
   if(this.isInitialized)
    this.RaiseFocus();
  }
  else
   this.UnlockFocusEvents();
 },
 OnLostFocusCore: function() {
  if(!this.IsFocusEventsLocked()){
   this.focused = false;
   if(ASPx.GetFocusedEditor() === this)
    ASPx.SetFocusedEditor(null);
   if(this.styleDecoration)
    this.styleDecoration.Update();
   this.RaiseLostFocus();
  }
 },
 OnFocus: function() {
  if(!this.specialKeyboardHandlingUsed)
   this.OnFocusCore();
 },
 OnLostFocus: function() {
  if(this.isInitialized && !this.specialKeyboardHandlingUsed)
   this.OnLostFocusCore();
 },
 OnSpecialFocus: function() {
  if(this.isInitialized)
   this.OnFocusCore();
 },
 OnSpecialLostFocus: function() {
  if(this.isInitialized)
   this.OnLostFocusCore();
 },
 OnMouseWheel: function(evt){
 },
 OnValidation: function(validationType) {
  if(this.customValidationEnabled && this.isInitialized && ASPx.IsExistsElement(this.GetMainElement()) &&
   (!this.IsErrorFrameDisplayed() || this.GetElementRequiredForErrorFrame())) {
   this.BeginErrorFrameUpdate();
   try {
    if(this.validateOnLeave || validationType != ValidationType.PersonalOnValueChanged) {
     this.SetIsValid(true, true );
     this.SetErrorText(this.initialErrorText, true );
     this.ValidateWithPatterns();
     this.RaiseValidation();
    }
    this.UpdateErrorFrameAndFocus(this.editorFocusingRequired(validationType));
   } finally {
    this.EndErrorFrameUpdate();
   }
   this.UpdateValidationSummaries(validationType);
   this.ariaExplanatoryTextManager.UpdateValidationState(validationType);
  }
 },
 GetElementRequiredForErrorFrame: function() {
  return this.GetExternalTable();
 },
 editorFocusingRequired: function(validationType) {
  return !this.GetIsValid() && ((validationType == ValidationType.PersonalOnValueChanged && this.validateOnLeave) ||
         (validationType == ValidationType.PersonalViaScript && this.setFocusOnError));
 },
 OnValueChanged: function() {
  var processOnServer = this.RaiseValidationInternal();
  processOnServer = this.RaiseValueChangedEvent() && processOnServer;
  if(processOnServer)
   this.SendPostBackInternal("");
 },
 ParseValue: function() {
 },
 RaisePersonalStandardValidation: function() {
  if(ASPx.IsFunction(window.ValidatorOnChange)) {
   var inputElement = this.GetValueInputToValidate();
   if(inputElement && inputElement.Validators)
    window.ValidatorOnChange({ srcElement: inputElement });
  }
 },
 RaiseValidationInternal: function() {
  if(this.isPostBackAllowed() && this.causesValidation && this.validateOnLeave)
   return ASPxClientEdit.ValidateGroup(this.validationGroup);
  else {
   this.OnValidation(ValidationType.PersonalOnValueChanged);
   return this.GetIsValid();
  }
 },
 RaiseValueChangedEvent: function(){
  return this.RaiseValueChanged();
 },
 SendPostBackInternal: function(postBackArg) {
  if(ASPx.IsFunction(this.sendPostBackWithValidation))
   this.sendPostBackWithValidation(postBackArg);
  else
   this.SendPostBack(postBackArg);
 },
 SetElementToBeFocused: function() {
  if(this.IsVisible())
   invalidEditorToBeFocused = this;
 },
 GetFocusSelectAction: function() {
  return null;
 },
 SetFocus: function() {
  var inputElement = this.GetFocusableInputElement();
  if(!inputElement) return; 
  var isIE9 = ASPx.Browser.IE && ASPx.Browser.Version >= 9;
  if((ASPx.GetActiveElement() != inputElement || isIE9) && _aspxIsEditorFocusable(inputElement))
   ASPx.SetFocus(inputElement, this.GetFocusSelectAction());
 },
 SetFocusOnError: function() {
  if(invalidEditorToBeFocused == this) {
   this.SetFocus();
   invalidEditorToBeFocused = null;
  }
 },
 BeginErrorFrameUpdate: function() {
  if(!this.errorFrameUpdateLocked)
   this.errorFrameUpdateLocked = true;
 },
 EndErrorFrameUpdate: function() {
  this.errorFrameUpdateLocked = false;
  var args = this.updateErrorFrameAndFocusLastCallArgs;
  if(args) {
   this.UpdateErrorFrameAndFocus(args[0], args[1]);
   delete this.updateErrorFrameAndFocusLastCallArgs;
  }
 },
 UpdateErrorFrameAndFocus: function(setFocusOnError, ignoreVisibilityCheck, isValid) {
  if(!this.GetEnabled() || !ignoreVisibilityCheck && !this.GetVisible())
   return;
  if(this.errorFrameUpdateLocked) {
   this.updateErrorFrameAndFocusLastCallArgs = [ setFocusOnError, ignoreVisibilityCheck ];
   return;
  }
  if(this.styleDecoration)
   this.styleDecoration.Update();
  if(typeof(isValid) == "undefined")
   isValid = this.GetIsValid();
  var externalTable = this.GetExternalTable();
  var isStaticDisplay = this.display == ErrorFrameDisplay.Static;
  if(isValid && this.IsErrorFrameDisplayed()) {
   if(isStaticDisplay) {
    this.HideErrorCell(true);
    ASPx.AddClassNameToElement(externalTable, ASPxEditExternalTableClassNames.ValidStaticTableClassName);
   } else {
    this.HideErrorCell();
    this.SaveControlCellStyles();
    this.ClearControlCellStyles();
    ASPx.AddClassNameToElement(externalTable, ASPxEditExternalTableClassNames.ValidDynamicTableClassName);
   }
  } else {
   var editorLocatedWithinVisibleContainer = this.IsVisible();
   if(this.IsErrorFrameDisplayed()) {
    this.UpdateErrorCellContent();
    if(isStaticDisplay) {
     this.ShowErrorCell(true);
     ASPx.RemoveClassNameFromElement(externalTable, ASPxEditExternalTableClassNames.ValidStaticTableClassName);
    } else {
     this.EnsureControlCellStylesLoaded();
     this.RestoreControlCellStyles();
     this.ShowErrorCell();
     ASPx.RemoveClassNameFromElement(externalTable, ASPxEditExternalTableClassNames.ValidDynamicTableClassName);
    }
   }
   if(editorLocatedWithinVisibleContainer) {
    if(setFocusOnError && this.setFocusOnError && invalidEditorToBeFocused == null) {
     this.SetElementToBeFocused();
     this.SetFocusOnError();
    }
   }
  }
 },
 ShowErrorCell: function (useVisibilityAttribute) {
  var errorCell = this.GetErrorCell();
  if(errorCell) {
   if(useVisibilityAttribute)
    ASPx.SetElementVisibility(errorCell, true);
   else
    ASPx.SetElementDisplay(errorCell, true);
  }
 },
 HideErrorCell: function(useVisibilityAttribute) {
  var errorCell = this.GetErrorCell();
  if(errorCell) {
   if(useVisibilityAttribute)
    ASPx.SetElementVisibility(errorCell, false);
   else
    ASPx.SetElementDisplay(errorCell, false);
  }
 },
 SaveControlCellStyles: function() {
  this.EnsureControlCellStylesLoaded();
 },
 EnsureControlCellStylesLoaded: function() {
  if(typeof(this.controlCellStyles) == "undefined") {
   var controlCell = this.GetControlCell();
   this.controlCellStyles = {
    cssClass: controlCell.className,
    style: this.ExtractElementStyleStringIgnoringVisibilityProps(controlCell)
   };
  }
 },
 ClearControlCellStyles: function() {
  this.ClearElementStyle(this.GetControlCell());
 },
 RestoreControlCellStyles: function() {
  var controlCell = this.GetControlCell();
  var externalTable = this.GetExternalTable();
  if(ASPx.Browser.WebKitFamily)
   this.MakeBorderSeparateForTable(externalTable);
  controlCell.className = this.controlCellStyles.cssClass;
  controlCell.style.cssText = this.controlCellStyles.style;
  if(ASPx.Browser.WebKitFamily)
   this.UndoBorderSeparateForTable(externalTable);
 },
 MakeBorderSeparateForTable: function(table) {
  ASPx.AddClassNameToElement(table, ASPxEditExternalTableClassNames.TableWithSeparateBordersClassName);
 },
 UndoBorderSeparateForTable: function(table) {
  setTimeout(function () {
   ASPx.RemoveClassNameFromElement(table, ASPxEditExternalTableClassNames.TableWithSeparateBordersClassName);
  }, 0);
 },
 ExtractElementStyleStringIgnoringVisibilityProps: function(element) {
  var savedVisibility = element.style.visibility;
  var savedDisplay = element.style.display;
  element.style.visibility = "";
  element.style.display = "";
  var styleStr = element.style.cssText;
  element.style.visibility = savedVisibility;
  element.style.display = savedDisplay;
  return styleStr;
 },
 ClearElementStyle: function(element) {
  if(!element)
   return;
  element.className = "";
  var excludedAttrNames = [
   "width", "display", "visibility",
   "position", "left", "top", "z-index",
   "margin", "margin-top", "margin-right", "margin-bottom", "margin-left",
   "float", "clear"
  ];
  var savedAttrValues = { };
  for(var i = 0; i < excludedAttrNames.length; i++) {
   var attrName = excludedAttrNames[i];
   var attrValue = element.style[attrName];
   if(attrValue)
    savedAttrValues[attrName] = attrValue;
  }
  element.style.cssText = "";
  for(var styleAttrName in savedAttrValues)
   element.style[styleAttrName] = savedAttrValues[styleAttrName];
 },
 Clear: function() {
  this.SetValue(null);
  this.SetIsValid(true);
  return true;
 },
 UpdateErrorCellContent: function() {
  if(this.errorDisplayMode.indexOf("t") > -1)
   this.UpdateErrorText();
  if(this.errorDisplayMode == "i")
   this.UpdateErrorImage();
 },
 UpdateErrorImage: function() {
  var image = this.GetErrorImage();
  if(ASPx.IsExistsElement(image)) {
   if(this.accessibilityCompliant) {
    ASPx.Attr.SetAttribute(image, "aria-label", this.errorText);
    var innerImg = ASPx.GetNodeByTagName(image, "IMG", 0);
    if(ASPx.IsExists(innerImg))
     innerImg.alt = this.errorText;
   }
   image.alt = this.errorText;
   image.title = this.errorText;
  } else {
   this.UpdateErrorText();
  }
 },
 UpdateErrorText: function() {
  var errorTextCell = this.GetErrorTextCell();
  if(ASPx.IsExistsElement(errorTextCell))
   errorTextCell.innerHTML = this.HtmlEncode(this.errorText);
 },
 ValidateWithPatterns: function() {
  if(this.validationPatterns.length > 0) {
   var value = this.GetValue();
   for(var i = 0; i < this.validationPatterns.length; i++) {
    var validator = this.validationPatterns[i];
    if(!validator.EvaluateIsValid(value)) {
     this.SetIsValid(false, true );
     this.SetErrorText(validator.errorText, true );
     return;
    }
   }
  }
 },
 OnSpecialKeyDown: function(evt){
  this.RaiseKeyDown(evt);
  var handler = this.keyDownHandlers[evt.keyCode];
  if(handler) 
   return this[handler](evt);
  return false;
 },
 OnSpecialKeyPress: function(evt){
  this.RaiseKeyPress(evt);
  var handler = this.keyPressHandlers[evt.keyCode];
  if(handler) 
   return this[handler](evt);
  if(ASPx.Browser.NetscapeFamily || ASPx.Browser.Opera){
   if(evt.keyCode == ASPx.Key.Enter)
    return this.enterProcessed;
  }
  return false;
 },
 OnSpecialKeyUp: function(evt){
  this.RaiseKeyUp(evt);
  var handler = this.keyUpHandlers[evt.keyCode];
  if(handler) 
   return this[handler](evt);
  return false;
 },
 OnKeyDown: function(evt) {
  if(!this.specialKeyboardHandlingUsed)
   this.RaiseKeyDown(evt);
 },
 OnKeyPress: function(evt) {
  if(!this.specialKeyboardHandlingUsed)
   this.RaiseKeyPress(evt);
 },
 OnKeyUp: function(evt) {
  if(!this.specialKeyboardHandlingUsed)
   this.RaiseKeyUp(evt);
 },
 RaiseKeyDown: function(evt){
  if(!this.KeyDown.IsEmpty()){
   var args = new ASPxClientEditKeyEventArgs(evt);
   this.KeyDown.FireEvent(this, args);
  }
 },
 RaiseKeyPress: function(evt){
  if(!this.KeyPress.IsEmpty()){
   var args = new ASPxClientEditKeyEventArgs(evt);
   this.KeyPress.FireEvent(this, args);
  }
 },
 RaiseKeyUp: function(evt){
  if(!this.KeyUp.IsEmpty()){
   var args = new ASPxClientEditKeyEventArgs(evt);
   this.KeyUp.FireEvent(this, args);
  }
 },
 RaiseFocus: function(){
  if(!this.GotFocus.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.GotFocus.FireEvent(this, args);
  }
 },
 RaiseLostFocus: function(){
  if(!this.LostFocus.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.LostFocus.FireEvent(this, args);
  }
 },
 RaiseValidation: function() {
  if(this.customValidationEnabled && !this.Validation.IsEmpty()) {
   var currentValue = this.GetValue();
   var args = new ASPxClientEditValidationEventArgs(currentValue, this.errorText, this.GetIsValid());
   this.Validation.FireEvent(this, args);
   this.SetErrorText(args.errorText, true );
   this.SetIsValid(args.isValid, true );
   if(args.value != currentValue)
    this.SetValue(args.value);
  }
 },
 RaiseValueChanged: function(){
  var processOnServer = this.isPostBackAllowed();
  if(!this.ValueChanged.IsEmpty()){
   var args = new ASPxClientProcessingModeEventArgs(processOnServer);
   this.ValueChanged.FireEvent(this, args);
   processOnServer = args.processOnServer;
  }
  return processOnServer;  
 },
 isPostBackAllowed: function() {
  return this.autoPostBack;
 },
 AddDecorationStyle: function(key, className, cssText) {
  if(!this.styleDecoration) 
   this.RequireStyleDecoration();
  this.styleDecoration.AddStyle(key, className, cssText);
 }, 
 RequireStyleDecoration: function() {
  this.styleDecoration = this.CreateStyleDecoration();
  this.PopulateStyleDecorationPostfixes();
 },
 CreateStyleDecoration: function() {
  return new ASPx.EditorStyleDecoration(this);
 },
 PopulateStyleDecorationPostfixes: function() {
  this.styleDecoration.AddPostfix("");
 },
 LockStyleDecorationUpdate: function() {
  if(this.styleDecoration)
   this.styleDecoration.LockUpdate();
 },
 UnlockStyleDecorationUpdate: function() {
  if(this.styleDecoration)
   this.styleDecoration.UnlockUpdate();
 },
 Focus: function(){
  this.SetFocus();
 },
 GetIsValid: function() {
  var hasRequiredInputElement = !this.RequireInputElementToValidate() || ASPx.IsExistsElement(this.GetInputElement());
  if(!hasRequiredInputElement || this.IsErrorFrameDisplayed() && !ASPx.IsExistsElement(this.GetElementRequiredForErrorFrame()))
   return true;
  return this.isValid;
 },
 RequireInputElementToValidate: function() {
  return true;
 },
 IsErrorFrameDisplayed: function() {
  return this.display !== ErrorFrameDisplay.None;
 },
 GetErrorText: function(){
  return this.errorText;
 },
 SetIsValid: function(isValid, validating){
  if(this.customValidationEnabled && this.isValid != isValid) {
   this.isValid = isValid;
   this.UpdateErrorFrameAndFocus(false );
   this.UpdateClientValidationState();
   if(!validating)
    this.UpdateValidationSummaries(ValidationType.PersonalViaScript);
  }
 },
 SetErrorText: function(errorText, validating){
  if(this.customValidationEnabled && this.errorText != errorText) {
   this.errorText = errorText;
   this.UpdateErrorFrameAndFocus(false );
   this.UpdateClientValidationState();
   if(!validating)
    this.UpdateValidationSummaries(ValidationType.PersonalViaScript);
  }
 },
 Validate: function(){
  this.ParseValue();
  this.OnValidation(ValidationType.PersonalViaScript);
 }
});
ASPx.Ident.scripts.ASPxClientEdit = true;
ASPx.focusedEditorName = "";
ASPx.GetFocusedEditor = function() {
 var focusedEditor = ASPx.GetControlCollection().Get(ASPx.focusedEditorName);
 if(focusedEditor && !focusedEditor.focused){
  ASPx.SetFocusedEditor(null);
  focusedEditor = null;
 }
 return focusedEditor;
}
ASPx.SetFocusedEditor = function(editor) {
 ASPx.focusedEditorName = editor ? editor.name : "";
}
ASPx.FindAssociatedLabelElements = function(editor) {
 var assocciatedLabels = [];
 var inputElement = editor.GetInputElement();
 if(!ASPx.IsExists(inputElement) || !inputElement.id) 
  return assocciatedLabels;
 var labels = ASPx.GetNodesByTagName(document, "LABEL");
 for(var i = 0; i < labels.length; i++) {
  if(!!labels[i].htmlFor && labels[i].htmlFor === inputElement.id)
   assocciatedLabels.push(labels[i]);
 }
 return assocciatedLabels;
}
var DisableAccessibilityExplanatoryTextManager = ASPx.CreateClass(null, {
 constructor: function(editor) {
  this.editor = editor;
 },
 GetAdditionalTextRowId: function() {
  return this.editor.name + EditElementSuffix.AccessibilityAdditionalTextRow;
 },
 GetErrorTextElement: function () {
  return !!this.editor.GetErrorTextCell() ? this.editor.GetErrorTextCell() : this.editor.GetErrorImage();
 },
 GetTextElement: function() { return null; },
 CreateAdditionalTextRow: function() { return null; },
 SetCaptionAssociating: function() { },
 UpdateText: function() { },
 UpdateValidationState: function(validationType) { },
 ToggleErrorAlert: function() { },
 SetOrRemoveText: function(accessibilityElements, textElement, setText, isLabel, isFirst) { }
});
var EditAccessibilityExplanatoryTextManager = ASPx.CreateClass(DisableAccessibilityExplanatoryTextManager, {
 constructor: function(editor) {
  this.constructor.prototype.constructor.call(this, editor);
  this.invisibleRowCssClassName = "dxAIR";
 },
 GetTextElement: function() {
  var mainElement = this.editor.GetMainElement();
  if(!mainElement) return null;
  var explanatoryText = "";
  var explanatoryTextElement = null;
  if(!!this.editor.nullText)
   explanatoryText = this.editor.nullText;
  else if(!!this.editor.helpTextObj)
   explanatoryTextElement = this.editor.helpTextObj.helpTextElement;
  else if(!!mainElement.title)
   explanatoryText = mainElement.title;
  if(!!explanatoryText && mainElement.tagName == "TABLE") {
   explanatoryTextElement = ASPx.GetElementById(this.GetAdditionalTextRowId());
   if(!explanatoryTextElement)
    explanatoryTextElement = this.CreateAdditionalTextRow();
   ASPx.SetInnerHtml(explanatoryTextElement.cells[0], explanatoryText);
  }
  return explanatoryTextElement;
 },
 CreateAdditionalTextRow: function() {
  var textRow = this.editor.GetMainElement().insertRow(-1);
  textRow.insertCell();
  textRow.id = this.GetAdditionalTextRowId();
  ASPx.AddClassNameToElement(textRow, this.invisibleRowCssClassName);
  return textRow;
 },
 SetCaptionAssociating: function() {
  var captionCell = this.editor.GetCaptionCell();
  if(!captionCell || captionCell.childNodes[0].tagName == "LABEL") return;
  var labelElement = captionCell.childNodes[0];
  ASPx.EditAccessibilityExplanatoryTextManager.SetLabelAssociating(this.editor, this.editor.GetAccessibilityFirstActiveElement(), labelElement);
 },
 UpdateText: function() {
  var additionalTextElement = this.GetTextElement();
  if(ASPx.IsExists(additionalTextElement)) {
   var pronounceElement = this.editor.GetAccessibilityFirstActiveElement();
   var hasAnyLabel = !!ASPx.Attr.GetAttribute(pronounceElement, "aria-label") || 
    !!ASPx.Attr.GetAttribute(pronounceElement, "aria-labelledby") ||
    ASPx.FindAssociatedLabelElements(this.editor).length > 0;
   this.SetOrRemoveText([pronounceElement], additionalTextElement, true, !hasAnyLabel, false);
  }
 },
 UpdateValidationState: function(validationType) {
  if(validationType == ValidationType.PersonalOnValueChanged && this.editor.accessibilityHelper) return;
  var accessibilityElements = this.editor.GetAccessibilityActiveElements();
  var errorTextElement = this.GetErrorTextElement();
  this.SetOrRemoveText(accessibilityElements, errorTextElement, !this.editor.isValid, false, true);
  if(accessibilityElements.length > 0 && !!errorTextElement) {
   for(var i = 0; i < accessibilityElements.length; i++) {
    if(!ASPx.IsExists(accessibilityElements[i])) continue;
    ASPx.Attr.SetOrRemoveAttribute(accessibilityElements[i], "aria-invalid", !this.editor.isValid);
   }
  }
 },
 ToggleErrorAlert: function() {
  var errorTextElement = this.GetErrorTextElement();
  ASPx.SetElementDisplay(errorTextElement, false);
  ASPx.Attr.SetAttribute(errorTextElement, 'role', 'alert');
  ASPx.SetElementDisplay(errorTextElement, true);
  setTimeout(function() { ASPx.Attr.RemoveAttribute(errorTextElement, 'role'); }, 500);
 },
 SetOrRemoveText: function(accessibilityElements, textElement, setText, isLabel, isFirst) {
  var idsRefAttribute = isLabel ? "aria-labelledby" : "aria-describedby";
  if(!textElement) return;
  var textId = !!textElement.id ? textElement.id : textElement.parentNode.id;
  for(var i = 0; i < accessibilityElements.length; i++) {
   if(!accessibilityElements[i]) continue;
   var descRefString = ASPx.Attr.GetAttribute(accessibilityElements[i], idsRefAttribute);
   var descRefIds = !!descRefString ? descRefString.split(" ") : [ ];
   var descIndex = descRefIds.indexOf(textId);
   if(setText && descIndex == -1)
    isFirst ? descRefIds.unshift(textId) : descRefIds.push(textId);
   else if(!setText && descIndex > -1)
    descRefIds.splice(descIndex, 1);
   ASPx.Attr.SetOrRemoveAttribute(accessibilityElements[i], idsRefAttribute, descRefIds.join(" "));
  }
 }
});
ASPx.DisableAccessibilityExplanatoryTextManager = DisableAccessibilityExplanatoryTextManager;
ASPx.EditAccessibilityExplanatoryTextManager = EditAccessibilityExplanatoryTextManager;
ASPx.EditAccessibilityExplanatoryTextManager.SetLabelAssociating = function(editor, activeElement, labelElement) {
 var clickHandler = function(evt) {
  if(editor && editor.OnAssociatedLabelClick)
   editor.OnAssociatedLabelClick(evt);
  else
   activeElement.click();
 };
 ASPx.Evt.AttachEventToElement(labelElement, "click", clickHandler);
 if(!!editor) {
  var hasAriaLabel = !!ASPx.Attr.GetAttribute(activeElement, "aria-label");
  editor.ariaExplanatoryTextManager.SetOrRemoveText([activeElement], labelElement, true, !hasAriaLabel, true);
 }
};
ASPxClientEdit.ClearEditorsInContainer = function(container, validationGroup, clearInvisibleEditors) {
 invalidEditorToBeFocused = null;
 ASPx.ProcessEditorsInContainer(container, ASPx.ClearProcessingProc, ASPx.ClearChoiceCondition, validationGroup, clearInvisibleEditors, true );
 ASPxClientEdit.ClearExternalControlsInContainer(container, validationGroup, clearInvisibleEditors);
}
ASPxClientEdit.ClearEditorsInContainerById = function(containerId, validationGroup, clearInvisibleEditors) {
 var container = document.getElementById(containerId);
 this.ClearEditorsInContainer(container, validationGroup, clearInvisibleEditors);
}
ASPxClientEdit.ClearGroup = function(validationGroup, clearInvisibleEditors) {
 return this.ClearEditorsInContainer(null, validationGroup, clearInvisibleEditors);
}
ASPxClientEdit.ValidateEditorsInContainer = function(container, validationGroup, validateInvisibleEditors) {
 var summaryCollection;
 if(ASPx.Ident.scripts.ASPxClientValidationSummary) {
  summaryCollection = ASPx.GetClientValidationSummaryCollection();
  summaryCollection.AllowNewErrorsAccepting(validationGroup);
 }
 var validationResult = ASPx.ProcessEditorsInContainer(container, ASPx.ValidateProcessingProc, _aspxValidateChoiceCondition, validationGroup, validateInvisibleEditors,
  false );
 validationResult.isValid = ASPxClientEdit.ValidateExternalControlsInContainer(container, validationGroup, validateInvisibleEditors) && validationResult.isValid;
 if(typeof(validateInvisibleEditors) == "undefined")
  validateInvisibleEditors = false;
 if(typeof(validationGroup) == "undefined")
  validationGroup = null;    
 ASPx.GetControlCollection().RaiseValidationCompleted(container, validationGroup,
 validateInvisibleEditors, validationResult.isValid, validationResult.firstInvalid, validationResult.firstVisibleInvalid);
 if(summaryCollection)
  summaryCollection.ForbidNewErrorsAccepting(validationGroup);
 if(!validationResult.isValid && !!validationResult.firstVisibleInvalid && validationResult.firstVisibleInvalid.accessibilityCompliant && !validationResult.firstVisibleInvalid.setFocusOnError) {
  var accessInvalidControl = validationResult.firstVisibleInvalid;
  if(!summaryCollection && !accessInvalidControl.focused) {
   var beforeDelayActiveElement = ASPx.GetActiveElement();
   setTimeout(function() {
    var currentActiveElement = ASPx.GetActiveElement();
    if(accessInvalidControl.focused || (currentActiveElement != beforeDelayActiveElement && ASPx.Attr.IsExistsAttribute(currentActiveElement, 'role')))
     return;
    accessInvalidControl.ariaExplanatoryTextManager.ToggleErrorAlert();
   }, 500);    
  }
 }
 return validationResult.isValid;
}
ASPxClientEdit.ValidateEditorsInContainerById = function(containerId, validationGroup, validateInvisibleEditors) {
 var container = document.getElementById(containerId);
 return this.ValidateEditorsInContainer(container, validationGroup, validateInvisibleEditors);
}
ASPxClientEdit.ValidateGroup = function(validationGroup, validateInvisibleEditors) {
 return this.ValidateEditorsInContainer(null, validationGroup, validateInvisibleEditors);
}
ASPxClientEdit.AreEditorsValid = function(containerOrContainerId, validationGroup, checkInvisibleEditors) {
 var container = typeof(containerOrContainerId) == "string" ? document.getElementById(containerOrContainerId) : containerOrContainerId;
 var checkResult = ASPx.ProcessEditorsInContainer(container, ASPx.EditorsValidProcessingProc, _aspxEditorsValidChoiceCondition, validationGroup,
  checkInvisibleEditors, false );
 checkResult.isValid = ASPxClientEdit.AreExternalControlsValidInContainer(containerOrContainerId, validationGroup, checkInvisibleEditors) && checkResult.isValid;
 return checkResult.isValid;
}
ASPxClientEdit.AreExternalControlsValidInContainer = function(containerId, validationGroup, validateInvisibleEditors) {
 if(ASPx.Ident.scripts.ASPxClientHtmlEditor)
  return ASPxClientHtmlEditor.AreEditorsValidInContainer(containerId, validationGroup, validateInvisibleEditors);
 return true;
}
ASPxClientEdit.ClearExternalControlsInContainer = function(containerId, validationGroup, validateInvisibleEditors) {
 if(ASPx.Ident.scripts.ASPxClientHtmlEditor)
  return ASPxClientHtmlEditor.ClearEditorsInContainer(containerId, validationGroup, validateInvisibleEditors);
 return true;
}
ASPxClientEdit.ValidateExternalControlsInContainer = function(containerId, validationGroup, validateInvisibleEditors) {
 if(ASPx.Ident.scripts.ASPxClientHtmlEditor)
  return ASPxClientHtmlEditor.ValidateEditorsInContainer(containerId, validationGroup, validateInvisibleEditors);
 return true;
}
var ASPxClientEditKeyEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(htmlEvent) {
  this.constructor.prototype.constructor.call(this);
  this.htmlEvent = htmlEvent;
 }
});
var ASPxClientEditValidationEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(value, errorText, isValid) {
  this.constructor.prototype.constructor.call(this);
  this.errorText = errorText;
  this.isValid = isValid;
  this.value = value;
 }
});
ASPx.ProcessEditorsInContainer = function(container, processingProc, choiceCondition, validationGroup, processInvisibleEditors, processDisabledEditors) {
 var allProcessedSuccessfull = true;
 var firstInvalid = null;
 var firstVisibleInvalid = null;
 var invalidEditorToBeFocused = null;
 ASPx.GetControlCollection().ForEachControl(function(control) {
  var needToProcessRatingControl = window.ASPxClientRatingControl && (control instanceof ASPxClientRatingControl) && processingProc === ASPx.ClearProcessingProc;
  if(!ASPx.Ident.isDialogInvisibleControl(control) && (ASPx.Ident.IsASPxClientEdit(control) || needToProcessRatingControl) && (processDisabledEditors || control.GetEnabled())) {
   var mainElement = control.GetMainElement();
   if(mainElement &&
    (container == null || ASPx.GetIsParent(container, mainElement)) &&
    (processInvisibleEditors || control.IsVisible()) &&
    (!choiceCondition || choiceCondition(control, validationGroup))) {
    var isSuccess = processingProc(control);
    if(!isSuccess) {
     allProcessedSuccessfull = false;
     if(firstInvalid == null)
      firstInvalid = control;
     var isVisible = control.IsVisible();
     if(isVisible && firstVisibleInvalid == null)
      firstVisibleInvalid = control;
     if(control.setFocusOnError && invalidEditorToBeFocused == null && isVisible)
      invalidEditorToBeFocused = control;
    }
   }
  }
 }, this);
 if(invalidEditorToBeFocused != null)
  invalidEditorToBeFocused.SetFocus();
 return new ASPxValidationResult(allProcessedSuccessfull, firstInvalid, firstVisibleInvalid);
}
var ASPxValidationResult = ASPx.CreateClass(null, {
 constructor: function(isValid, firstInvalid, firstVisibleInvalid) {
  this.isValid = isValid;
  this.firstInvalid = firstInvalid;
  this.firstVisibleInvalid = firstVisibleInvalid;
 }
});
ASPx.ClearChoiceCondition = function(edit, validationGroup) {
 return !ASPx.IsExists(validationGroup) || (edit.validationGroup == validationGroup);
}
function _aspxValidateChoiceCondition(edit, validationGroup) {
 return ASPx.ClearChoiceCondition(edit, validationGroup) && edit.customValidationEnabled;
}
function _aspxEditorsValidChoiceCondition(edit, validationGroup) {
 return _aspxValidateChoiceCondition(edit, validationGroup);
}
function wrapLostFocusHandler(handler) {
 if(ASPx.Browser.Edge) {
  return function(name) {
   var edit = ASPx.GetControlCollection().Get(name);
   if(edit && !ASPx.IsElementVisible(edit.GetMainElement()))
    setTimeout(handler, 0, name);
   else
    handler(name);
  };
 }
 return handler;
};
ASPx.EGotFocus = function(name) {
 var edit = ASPx.GetControlCollection().Get(name); 
 if(!edit) return;
 if(!edit.isInitialized){
  var inputElement = edit.GetFocusableInputElement();
  if(inputElement && inputElement === document.activeElement)
   ASPx.Browser.Firefox ? window.setTimeout(function() { document.activeElement.blur(); }, 0) : document.activeElement.blur();
  return;
 }
  if(ASPx.Browser.VirtualKeyboardSupported) {
  ASPx.VirtualKeyboardUI.onCallingVirtualKeyboard(edit, false);
 } else {
  edit.OnFocus();
 }
}
ASPx.ELostFocusCore = function(name) {
 if(ASPx.Browser.VirtualKeyboardSupported) {
  var supressLostFocus = ASPx.VirtualKeyboardUI.isInputNativeBluring();
  if(supressLostFocus)
   return;
  ASPx.VirtualKeyboardUI.resetFocusedEditor();
 }
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) 
  edit.OnLostFocus();
}
ASPx.ELostFocus = wrapLostFocusHandler(ASPx.ELostFocusCore);
ASPx.ESGotFocus = function(name) {
 var edit = ASPx.GetControlCollection().Get(name); 
 if(!edit) return;
   if(ASPx.Browser.VirtualKeyboardSupported) {
  ASPx.VirtualKeyboardUI.onCallingVirtualKeyboard(edit, true);
 } else {
  edit.OnSpecialFocus();
 }
}
ASPx.ESLostFocusCore = function(name) {
 if(ASPx.Browser.VirtualKeyboardSupported) {
  var supressLostFocus = ASPx.VirtualKeyboardUI.isInputNativeBluring();
  if(supressLostFocus)
   return;
  ASPx.VirtualKeyboardUI.resetFocusedEditor();
 }
 var edit = ASPx.GetControlCollection().Get(name);
 if(!edit) return;
 if(edit.UseDelayedSpecialFocus())
  edit.specialFocusTimer = window.setTimeout(function() { edit.OnSpecialLostFocus(); }, 30);
 else
  edit.OnSpecialLostFocus();
}
ASPx.ESLostFocus = wrapLostFocusHandler(ASPx.ESLostFocusCore);
ASPx.EValueChanged = function(name) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null)
  edit.OnValueChanged();
}
ASPx.VirtualKeyboardUI = (function() {
 var focusedEditor = null;
 var inputNativeFocusLocked = false;
 function elementBelongsToEditor(element) {
  if(!element) return false;
  var isBelongsToEditor = false;
  ASPx.GetControlCollection().ForEachControl(function(control) {
   if(ASPx.Ident.IsASPxClientEdit(control) && control.IsEditorElement(element)) {
    isBelongsToEditor = true;
    return true;
   }
  }, this);
  return isBelongsToEditor;
 }
 function elementBelongsToFocusedEditor(element) {
  return focusedEditor && focusedEditor.IsEditorElement(element);
 }
 return {
  onTouchStart: function (evt) {
   if (!ASPx.Browser.VirtualKeyboardSupported) return;
   inputNativeFocusLocked = false;
   if(ASPx.TouchUIHelper.pointerEnabled) {
    if(evt.pointerType != ASPx.TouchUIHelper.pointerType.Touch)
     return;
    this.processFocusEditorControl(evt);
   } else
    ASPx.TouchUIHelper.handleFastTapIfRequired(evt,  function(){ this.processFocusEditorControl(evt); }.aspxBind(this), false);
  },
  processFocusEditorControl: function(evt) {
   var evtSource = ASPx.Evt.GetEventSource(evt);
   var timeEditHasAppliedFocus = focusedEditor && (ASPx.Ident.IsASPxClientTimeEdit && ASPx.Ident.IsASPxClientTimeEdit(focusedEditor));
   var focusedTimeEditBelongsToDateEdit = timeEditHasAppliedFocus && focusedEditor.OwnerDateEdit && focusedEditor.OwnerDateEdit.GetShowTimeSection();
   if(focusedTimeEditBelongsToDateEdit) {
    focusedEditor.OwnerDateEdit.ForceRefocusTimeSectionTimeEdit(evtSource);
    return;
   }
   var elementWithNativeFocus = ASPx.GetActiveElement();
   var someEditorInputIsFocused = elementBelongsToEditor(elementWithNativeFocus);
   var touchKeyboardIsVisible = someEditorInputIsFocused;
   var tapOutsideEditorAndInputs = !elementBelongsToEditor(evtSource) && !ASPx.Ident.IsFocusableElementRegardlessTabIndex(evtSource);
   var blurToHideTouchKeyboard = touchKeyboardIsVisible && tapOutsideEditorAndInputs;
   if(blurToHideTouchKeyboard) {
    elementWithNativeFocus.blur();
    return;
   }
   var tapOutsideFocusedEditor = focusedEditor && !elementBelongsToFocusedEditor(evtSource);
   if(tapOutsideFocusedEditor) {
    var focusedEditorWithBluredInput = !elementBelongsToFocusedEditor(elementWithNativeFocus);
    if(focusedEditorWithBluredInput) 
     this.lostAppliedFocusOfEditor();
   }
  },
  smartFocusEditor: function(edit) {
   if(!edit.focused) {
    this.setInputNativeFocusLocked(true);
    this.setFocusEditorCore(edit);
   } else {
    edit.ForceRefocusEditor();
   }
  },
  setFocusEditorCore: function(edit) {
   if(ASPx.Browser.MacOSMobilePlatform) {
    var timeoutDuration = ASPx.Browser.Chrome ? 250 : 30;
    window.setTimeout(function(){ edit.SetFocus(); }, timeoutDuration);
   } else {
    edit.SetFocus();
   }
  },
  onCallingVirtualKeyboard: function(edit, isSpecial) {
   this.setAppliedFocusOfEditor(edit, isSpecial);
   if(edit.specialKeyboardHandlingUsed == isSpecial && inputNativeFocusLocked)
    edit.BlurInputElement();
  },
  isInputNativeBluring: function() {
   return focusedEditor && inputNativeFocusLocked;
  },
  setInputNativeFocusLocked: function(locked) {
   inputNativeFocusLocked = locked;
  },
  getInputNativeFocusLocked: function() {
   return inputNativeFocusLocked;
  },
  setAppliedFocusOfEditor: function(edit, isSpecial) {
   if(focusedEditor === edit) {
    if(edit.specialKeyboardHandlingUsed == isSpecial) {
     focusedEditor.UnlockFocusEvents();
     if(focusedEditor.EnsureClearButtonVisibility)
      focusedEditor.EnsureClearButtonVisibility();
    }
    return;
   }
   if(edit.specialKeyboardHandlingUsed == isSpecial) {
    this.lostAppliedFocusOfEditor();
    focusedEditor = edit;
    ASPx.SetFocusedEditor(edit);
   }
   if(isSpecial)
    edit.OnSpecialFocus();
   else
    edit.OnFocus();
  },
  lostAppliedFocusOfEditor: function() {
   if(!focusedEditor) return;
   var curEditorName = focusedEditor.name; 
   var skbdHandlingUsed = focusedEditor.specialKeyboardHandlingUsed;
   var focusedEditorInputElementExists = focusedEditor.GetInputElement();
   focusedEditor = null;
   if(!focusedEditorInputElementExists)
    return;
   ASPx.ELostFocusCore(curEditorName);
   if(skbdHandlingUsed)
    ASPx.ESLostFocusCore(curEditorName);
  },
  getFocusedEditor: function() {
   return focusedEditor;
  },
  resetFocusedEditor: function() {
   focusedEditor = null;
  },
  focusableInputElementIsActive: function(edit) {
   var inputElement = edit.GetFocusableInputElement();
   return !!inputElement ? ASPx.GetActiveElement() === inputElement : false;
  }
 }
})();
if(ASPx.Browser.VirtualKeyboardSupported) {
 var touchEventName = ASPx.TouchUIHelper.pointerEnabled ? ASPx.TouchUIHelper.pointerDownEventName : 'touchstart';
 ASPx.Evt.AttachEventToDocument(touchEventName, function(evt){ ASPx.VirtualKeyboardUI.onTouchStart(evt); });
}
ASPx.Evt.AttachEventToDocument("mousedown", function(evt) {
 var editor = ASPx.GetFocusedEditor();
 if(!editor) 
  return;
 var evtSource = ASPx.Evt.GetEventSource(evt);
 if(editor.IsClearButtonElement(evtSource))
  return;
 if(editor.OwnerDateEdit && editor.OwnerDateEdit.GetShowTimeSection()) {
  editor.OwnerDateEdit.ForceRefocusTimeSectionTimeEdit(evtSource);
  return;
 }
 if(editor.IsEditorElement(evtSource) && !editor.IsElementBelongToInputElement(evtSource))
  editor.ForceRefocusEditor(evt);
});
ASPx.Evt.AttachEventToDocument(ASPx.Evt.GetMouseWheelEventName(), function(evt) {
 var editor = ASPx.GetFocusedEditor();
 if(editor != null && ASPx.IsExistsElement(editor.GetMainElement()) && editor.focused && editor.receiveGlobalMouseWheel)
  editor.OnMouseWheel(evt);
});
ASPx.KBSIKeyDown = function(name, evt){
 var control = ASPx.GetControlCollection().Get(name);
 if(control != null){
  var isProcessed = control.OnSpecialKeyDown(evt);
  if(isProcessed)
   return ASPx.Evt.PreventEventAndBubble(evt);
 }
}
ASPx.KBSIKeyPress = function(name, evt){
 var control = ASPx.GetControlCollection().Get(name);
 if(control != null){
  var isProcessed = control.OnSpecialKeyPress(evt);
  if(isProcessed)
   return ASPx.Evt.PreventEventAndBubble(evt);
 }
}
ASPx.KBSIKeyUp = function(name, evt){
 var control = ASPx.GetControlCollection().Get(name);
 if(control != null){
  var isProcessed = control.OnSpecialKeyUp(evt);
  if(isProcessed)
   return ASPx.Evt.PreventEventAndBubble(evt);
 }
}
ASPx.ClearProcessingProc = function(edit) {
 return edit.Clear();
}
ASPx.ValidateProcessingProc = function(edit) {
 edit.OnValidation(ValidationType.MassValidation);
 return edit.GetIsValid();
}
ASPx.EditorsValidProcessingProc = function(edit) {
 return edit.GetIsValid();
}
var CheckEditElementHelper = ASPx.CreateClass(ASPx.CheckableElementHelper, {
 AttachToMainElement: function(internalCheckBox) {
  ASPx.CheckableElementHelper.prototype.AttachToMainElement.call(this, internalCheckBox);
  this.AttachToLabelElement(this.GetLabelElement(internalCheckBox.container), internalCheckBox);
 },
 AttachToLabelElement: function(labelElement, internalCheckBox) {
  var _this = this;
  if(labelElement) {
   ASPx.Evt.AttachEventToElement(labelElement, "click", 
    function (evt) { 
     _this.InvokeClick(internalCheckBox, evt);
    }
   );
   ASPx.Evt.AttachEventToElement(labelElement, "mousedown",
    function (evt) {
     internalCheckBox.Refocus();
    }
   );
  }
 },
 GetLabelElement: function(container) {
  var labelElement = ASPx.GetNodeByTagName(container, "LABEL", 0);
  if(!labelElement) {
   var labelCell = ASPx.GetNodeByClassName(container, "dxichTextCellSys", 0);
   labelElement = ASPx.GetNodeByTagName(labelCell, "SPAN", 0);
  }
  return labelElement;
 }
});
CheckEditElementHelper.Instance = new CheckEditElementHelper();
var CalendarSharedParameters = ASPx.CreateClass(null, {
 updateCalendarCallbackCommand: "UPDATE",
 constructor: function() {
  this.minDate = null;
  this.maxDate = null;
  this.disabledDates = [];
  this.calendarCustomDraw = false;
  this.hasCustomDisabledDatesViaCallback = false;
  this.dateRangeMode = false;
  this.currentDateEdit = null;
  this.DaysSelectingOnMouseOver = new ASPxClientEvent();
  this.VisibleDaysMouseOut = new ASPxClientEvent();
  this.CalendarSelectionChangedInternal = new ASPxClientEvent();
 },
 Assign: function(source) {
  this.minDate = source.minDate ? source.minDate : null;
  this.maxDate = source.maxDate ? source.maxDate : null;
  this.calendarCustomDraw = source.calendarCustomDraw ? source.calendarCustomDraw : false;
  this.hasCustomDisabledDatesViaCallback = source.hasCustomDisabledDatesViaCallback ? source.hasCustomDisabledDatesViaCallback : false;
  this.disabledDates = source.disabledDates ? source.disabledDates : [];
  this.currentDateEdit = source.currentDateEdit ? source.currentDateEdit : null;
 },
 GetUpdateCallbackParameters: function() {
  var callbackArgs = this.GetCallbackArgs();
  callbackArgs = this.FormatCallbackArg(this.updateCalendarCallbackCommand, callbackArgs);
  return callbackArgs;
 },
 GetCallbackArgs: function() {
  var args = {};
  if(this.minDate)
   args.clientMinDate = ASPx.DateUtils.GetInvariantDateString(this.minDate);
  if(this.maxDate)
   args.clientMaxDate = ASPx.DateUtils.GetInvariantDateString(this.maxDate);
  for(key in args) {
   var jsonArgs = JSON.stringify(args);
   return ASPx.Str.EncodeHtml(jsonArgs);
  }
  return null;
 },
 FormatCallbackArg: function(prefix, arg) {
  if(!arg) return prefix;
  return [prefix, '|', arg.length, ';', arg, ';'].join('');
 }
});
ASPx.CalendarSharedParameters = CalendarSharedParameters;
ASPx.ValidationType = ValidationType;
ASPx.ErrorFrameDisplay = ErrorFrameDisplay;
ASPx.EditElementSuffix = EditElementSuffix;
ASPx.ValidationPattern = ValidationPattern;
ASPx.RequiredFieldValidationPattern = RequiredFieldValidationPattern;
ASPx.RegularExpressionValidationPattern = RegularExpressionValidationPattern;
ASPx.CheckEditElementHelper = CheckEditElementHelper;
ASPx.IsEditorFocusable = _aspxIsEditorFocusable;
window.ASPxClientEditBase = ASPxClientEditBase;
window.ASPxClientEdit = ASPxClientEdit;
window.ASPxClientEditKeyEventArgs = ASPxClientEditKeyEventArgs;
window.ASPxClientEditValidationEventArgs = ASPxClientEditValidationEventArgs;
})();

(function() {
ASPx.TEInputSuffix = "_I";
ASPx.PasteCheckInterval = 50;
ASPx.TEHelpTextElementSuffix = "_HTE";
var passwordInputClonedSuffix = "_CLND";
var memoMinHeight = 34;
var BrowserHelper = {
 SAFARI_SYSTEM_CLASS_NAME: "dxeSafariSys",
 MOBILE_SAFARI_SYSTEM_CLASS_NAME: "dxeIPadSys",
 GetBrowserSpecificSystemClassName: function() {
  if(ASPx.Browser.Safari)
   return ASPx.Browser.MacOSMobilePlatform ? this.MOBILE_SAFARI_SYSTEM_CLASS_NAME : this.SAFARI_SYSTEM_CLASS_NAME;
  return "";
 }
};
var ASPxClientTextEdit = ASPx.CreateClass(ASPxClientEdit, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);      
  this.isASPxClientTextEdit = true;
  this.nullText = "";
  this.escCount = 0;
  this.raiseValueChangedOnEnter = true;
  this.autoResizeWithContainer = false;
  this.lastChangedValue = null;
  this.autoCompleteAttribute = null;
  this.passwordNullTextIntervalID = -1;
  this.nullTextInputElement = null;
  this.helpText = "";
  this.helpTextObj = null;  
  this.helpTextStyle = [];
  this.externalTableStyle = [];
  this.helpTextPosition = ASPx.Position.Right;
  this.helpTextMargins = null;
  this.helpTextHAlign = ASPxClientTextEditHelpTextHAlign.Left;
  this.helpTextVAlign = ASPxClientTextEditHelpTextVAlign.Top;
  this.enableHelpTextPopupAnimation = true;
  this.helpTextDisplayMode = ASPxClientTextEditHelpTextDisplayMode.Inline;
  this.maskInfo = null;  
  this.maskValueBeforeUserInput = "";
  this.maskPasteTimerID = -1;
  this.maskPasteLock = false;    
  this.maskPasteCounter = 0;
  this.maskTextBeforePaste = "";    
  this.maskHintHtml = "";
  this.maskHintTimerID = -1;
  this.maskedEditorClickEventHandlers = [];
  this.errorCellPosition = ASPx.Position.Right;
  this.displayFormat = null;
  this.TextChanged = new ASPxClientEvent();
 },
 InitializeProperties: function(properties){
  ASPxClientEdit.prototype.InitializeProperties.call(this, properties);
  if(properties.maskInfo) {
   this.maskInfo = ASPx.MaskInfo.Create(properties.maskInfo.maskText, properties.maskInfo.dateTimeOnly, properties.maskInfo.allowEscapingInEnums);
   this.SetProperties(properties.maskInfo.properties, this.maskInfo);
  }
 },
 Initialize: function(){
  this.SaveChangedValue();
  ASPxClientEdit.prototype.Initialize.call(this);
  this.CorrectInputMaxLength();
  this.SubscribeToIeDropEvent();
  if(ASPx.Browser.WebKitFamily)  
   this.CorrectMainElementWhiteSpaceStyle();
  if(this.GetInputElement().type == "password")
   this.ToggleTextDecoration();
 },
 InlineInitialize: function(){
  ASPxClientEdit.prototype.InlineInitialize.call(this);
  if(this.maskInfo != null)
   this.InitMask();
  this.ApplyBrowserSpecificClassName();
  this.helpTextInitialize();
  if(ASPx.Browser.IE && ASPx.Browser.Version >= 10 && this.nullText != "")
   this.addIEXButtonEventHandler();
  if(this.autoCompleteAttribute)
   this.GetInputElement().setAttribute(this.autoCompleteAttribute.name, this.autoCompleteAttribute.value);
 },
 InitializeEvents: function() {
  ASPxClientEdit.prototype.InitializeEvents.call(this);
  ASPx.Evt.AttachEventToElement(this.GetInputElement(), "keydown", this.OnKeyDown.aspxBind(this));
  ASPx.Evt.AttachEventToElement(this.GetInputElement(), "keyup", this.OnKeyUp.aspxBind(this));
  ASPx.Evt.AttachEventToElement(this.GetInputElement(), "keypress", this.OnKeyPress.aspxBind(this));
 },
 AdjustControl: function() {
  ASPxClientEdit.prototype.AdjustControl.call(this);
  if(ASPx.Browser.IE && ASPx.Browser.Version > 8 && !this.isNative)
   this.correctInputElementHeight();
 },
 correctInputElementHeight: function() {
  var mainElement = this.GetMainElement();
  if(mainElement) {
   var mainElementHeight = mainElement.style.height;
   var mainElementHeightSpecified = mainElementHeight && mainElementHeight.indexOf('px') !== -1; 
   if(mainElementHeightSpecified) {
    var inputElement = this.GetInputElement();
    var inputElementHeight = this.getInputElementHeight();
    inputElement.style.height = inputElementHeight + "px";
    if(!ASPx.Ident.IsASPxClientMemo(this))
     inputElement.style.lineHeight = inputElementHeight + "px";
   }
  }
 },
 getInputElementHeight: function() {
  var mainElement = this.GetMainElement(),
   inputElement = this.GetInputElement();
  var inputElementHeight = ASPx.PxToInt(mainElement.style.height) - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(mainElement);
  var inputElementContainer = inputElement.parentNode,
   inputContainerStyle = ASPx.GetCurrentStyle(inputElementContainer);
  inputElementHeight -= ASPx.GetTopBottomBordersAndPaddingsSummaryValue(inputElementContainer, inputContainerStyle) 
   + ASPx.GetTopBottomMargins(inputElementContainer, inputContainerStyle);
  var mainElementCellspacing = ASPx.GetCellSpacing(mainElement);
  if(mainElementCellspacing)
   inputElementHeight -= mainElementCellspacing * 2;
  var inputStyle = ASPx.GetCurrentStyle(inputElement);
  inputElementHeight -= ASPx.GetTopBottomBordersAndPaddingsSummaryValue(inputElement, inputStyle) 
   + ASPx.GetTopBottomMargins(inputElement, inputStyle);
  return inputElementHeight;
 },
 addIEXButtonEventHandler: function() {
  var inputElement = this.GetInputElement()
  if(ASPx.IsExists(inputElement)) {
   this.isDeleteOrBackspaceKeyClick = false;
   ASPx.Evt.AttachEventToElement(inputElement, "input", function (evt) {
    if(this.isDeleteOrBackspaceKeyClick) {
     this.isDeleteOrBackspaceKeyClick = false;
     return;
    }
    if(inputElement.value === '') {
     this.SyncRawValue();
    }
   }.aspxBind(this));
   ASPx.Evt.AttachEventToElement(inputElement, "keydown", function (evt) {
    this.isDeleteOrBackspaceKeyClick = (evt.keyCode == ASPx.Key.Delete || evt.keyCode == ASPx.Key.Backspace);
   }.aspxBind(this));
  }   
 },
 ensureOutOfRangeWarningManager: function (minValue, maxValue, defaultMinValue, defaultMaxValue, valueFormatter) {
  if (!this.outOfRangeWarningManager)
   this.outOfRangeWarningManager = new ASPxOutOfRangeWarningManager(this, minValue, maxValue, defaultMinValue, defaultMaxValue,
    this.showOutOfRangeWarningElementAtBottom() ? ASPx.Position.Bottom : ASPx.Position.Right, valueFormatter);
 },
 showOutOfRangeWarningElementAtBottom: function() {
  return this.hasRightPopupHelpText();
 },
 GetOutOfRangeWarningElementPrevSibling: function() {
  return this.GetMainElement();
 },
 helpTextInitialize: function () {
  if(this.helpText) {
   this.helpTextObj = new ASPxClientTextEditHelpText(this, this.helpTextStyle, this.helpText, this.helpTextPosition,
    this.helpTextHAlign, this.helpTextVAlign, this.helpTextMargins, this.enableHelpTextPopupAnimation, this.helpTextDisplayMode);
  }
 },
 hasPopupHelpText: function() {
  return this.helpText && this.helpTextDisplayMode === ASPxClientTextEditHelpTextDisplayMode.Popup;
 },
 hasRightPopupHelpText: function() {
  return this.hasPopupHelpText() && this.helpTextPosition === ASPx.Position.Right;
 },
 showHelpText: function () {
  if(this.helpTextObj)
   this.helpTextObj.show();
 },
 hideHelpText: function () {
  if(this.helpTextObj)
   this.helpTextObj.hide();
 },
 ApplyBrowserSpecificClassName: function() {
  var mainElement = this.GetMainElement();
  if(ASPx.IsExistsElement(mainElement)) {
   var className = BrowserHelper.GetBrowserSpecificSystemClassName();
   if(className)
    mainElement.className += " " + className;
  }
 },
  CorrectMainElementWhiteSpaceStyle: function() {
  var inputElement = this.GetInputElement();
  if(inputElement && inputElement.parentNode) {
   if(this.IsElementHasWhiteSpaceStyle(inputElement.parentNode))
    inputElement.parentNode.style.whiteSpace = "normal";
  }
 },
 IsElementHasWhiteSpaceStyle: function(element) {
  var currentStyle = ASPx.GetCurrentStyle(element);
  return currentStyle.whiteSpace == "nowrap" || currentStyle.whiteSpace == "pre";  
 },
 FindInputElement: function(){
  return this.isNative ? this.GetMainElement() : ASPx.GetElementById(this.name + ASPx.TEInputSuffix);
 },
 DecodeRawInputValue: function(value) {
  return value;
 },
 GetRawValue: function(value){
  return ASPx.IsExists(this.stateObject) ? this.stateObject.rawValue : null;
 },
 SetRawValue: function(value){
  if(ASPx.IsExists(value))
   value = value.toString();
  this.UpdateStateObjectWithObject({ rawValue: value });
 },
 SyncRawValue: function() {
  if(this.maskInfo != null)
   this.SetRawValue(this.maskInfo.GetValue());
  else
   this.SetRawValue(this.GetInputElement().value);
 },
 HasTextDecorators: function() {
  return this.nullText != "" || this.displayFormat != null;
 },
 CanApplyTextDecorators: function(){
  return !this.focused;
 },
 GetDecoratedText: function(value) {
  if(this.IsNull(value) && this.nullText != "") {
   if(this.CanApplyNullTextDecoration) {
    if(this.CanApplyNullTextDecoration())
     return this.nullText;
   } else {
    return this.nullText;
   }
  }
  if(this.displayFormat != null)
   return this.GetDisplayFormatText(value);
  if(this.maskInfo != null)
   return this.maskInfo.GetText();
  if(value == null)
   return "";
  return value;
 },
 GetDisplayFormatText: function(value) {
  return ASPx.Formatter.Format(this.displayFormat, value);
 },
 ToggleTextDecoration: function() {
  if(this.HasTextDecorators()) {
   if(this.focused) {
    var input = this.GetInputElement();
    var oldValue = input.value;
    var sel = ASPx.Selection.GetExtInfo(input);
    this.ToggleTextDecorationCore();
    if(oldValue != input.value || !ASPx.Selection.AreEqual(sel, ASPx.Selection.GetExtInfo(input))) {
     if(sel.startPos == 0 && sel.endPos == oldValue.length)
      sel.endPos = input.value.length;
     else
      sel.endPos = sel.startPos;
     if(!this.accessibilityCompliant || ASPx.GetActiveElement() == input)
      this.SetSelectionOnToggleTextDecoration(input, sel);
    }
   } else
    this.ToggleTextDecorationCore();
  }
 },
 SetSelectionOnToggleTextDecoration: function(input, sel) {
  ASPx.Selection.Set(input, sel.startPos, sel.endPos);
 },
 ToggleTextDecorationCore: function() {
  if(this.maskInfo != null) {   
   this.ApplyMaskInfo(false);
  } else {
   var input = this.GetInputElement();
   var rawValue = this.GetRawValue();
   var value = this.CanApplyTextDecorators() ? this.GetDecoratedText(rawValue) : rawValue;
   if(input.value != value) {
    if(input.type == "password")
     this.TogglePasswordInputTextDecoration(value);
    else
     input.value = value;
   }
  }
 },
 GetPasswordNullTextInputElement: function() {
  if(!this.isPasswordNullTextInputElementExists())
   this.nullTextInputElement = this.createPasswordNullTextInputElement();
  return this.nullTextInputElement;
 },
 createPasswordNullTextInputElement: function() {
  var inputElement = this.GetInputElement(),
   nullTextInputElement = document.createElement("INPUT");
  nullTextInputElement.className = inputElement.className;
  nullTextInputElement.style.cssText = inputElement.style.cssText;
  nullTextInputElement.id = inputElement.id + passwordInputClonedSuffix;
  nullTextInputElement.type = "text";
  if(ASPx.IsExists(inputElement.tabIndex))
   nullTextInputElement.tabIndex = inputElement.tabIndex;
  var onFocusEventHandler = function() {
   var inputElement = this.GetInputElement(),
    nullTextInputElement = this.GetPasswordNullTextInputElement();
   if(inputElement) {
    this.LockFocusEvents();  
    ASPx.SetElementDisplay(inputElement, true);
    inputElement.focus();
    ASPx.SetElementDisplay(nullTextInputElement, false);
    this.ReplaceAssociatedIdInLabels(nullTextInputElement.id, inputElement.id);
   }
  }.aspxBind(this);
  ASPx.Evt.AttachEventToElement(nullTextInputElement, "focus", onFocusEventHandler);
  return nullTextInputElement;
 },
 isPasswordNullTextInputElementExists: function() {
  return ASPx.IsExistsElement(this.nullTextInputElement);
 },
 TogglePasswordNullTextTimeoutChecker: function() {
  if(this.passwordNullTextIntervalID < 0) {
   var timeoutChecker = function() {
    var inputElement = this.GetInputElement();
    if(ASPx.GetControlCollection().GetByName(this.name) !== this || inputElement == null) {
     window.clearTimeout(this.passwordNullTextIntervalID);
     this.passwordNullTextIntervalID = -1;
     return;
    } else {
     if(!this.focused) {
      var passwordNullTextInputElement = this.GetPasswordNullTextInputElement();
      if(passwordNullTextInputElement.value != this.nullText && inputElement.value == "") { 
       passwordNullTextInputElement.value = this.nullText;
       this.SetValue(null);
      }
      if(inputElement.value != "") {
       if(inputElement.style.display == "none") {
        this.SetValue(inputElement.value);
        this.UnhidePasswordInput();
       }
      } else {
       if(inputElement.style.display != "none") {
        this.SetValue(null);
        this.HidePasswordInput();
       }
      }
     }
    }
   }.aspxBind(this);
   timeoutChecker(); 
   this.passwordNullTextIntervalID = window.setInterval(timeoutChecker, 100);
  }
 },
 TogglePasswordInputTextDecoration: function(value) {
  var inputElement = this.GetInputElement();
  var nullTextInputElement = this.GetPasswordNullTextInputElement();
  nullTextInputElement.value = value;
  var parentNode = inputElement.parentNode;
  if(ASPx.Data.ArrayIndexOf(parentNode.childNodes, nullTextInputElement) < 0) {
   ASPx.Attr.ChangeStyleAttribute(nullTextInputElement, "display", "none");
   parentNode.appendChild(nullTextInputElement);
  }
  this.HidePasswordInput();
  this.TogglePasswordNullTextTimeoutChecker();
 },
 HidePasswordInput: function() {
  ASPx.Attr.ChangeStyleAttribute(this.GetInputElement(), "display", "none");
  ASPx.Attr.ChangeStyleAttribute(this.GetPasswordNullTextInputElement(), "display", "");
  this.ReplaceAssociatedIdInLabels(this.GetInputElement().id, this.GetPasswordNullTextInputElement().id);
 },
 UnhidePasswordInput: function() {
  ASPx.Attr.ChangeStyleAttribute(this.GetInputElement(), "display", "");
  ASPx.Attr.ChangeStyleAttribute(this.GetPasswordNullTextInputElement(), "display", "none");
  this.ReplaceAssociatedIdInLabels(this.GetPasswordNullTextInputElement().id, this.GetInputElement().id);
 },
 ReplaceAssociatedIdInLabels: function(oldId, newId) {
  var labels = document.getElementsByTagName("LABEL");
  for(var i = 0; i < labels.length; i++) {
   if(labels[i].attributes["for"] && labels[i].attributes["for"].value == oldId)
    labels[i].attributes["for"].value = newId;
  }
 },
 GetFormattedText: function() {
  var value = this.GetValue();
  if(this.IsNull(value) && this.nullText != "")
   return this.GetText();
  return this.GetDecoratedText(value);
 },
 IsNull: function(value) {
  return value == null || value === "";
 },
 PopulateStyleDecorationPostfixes: function() {
  ASPxClientEdit.prototype.PopulateStyleDecorationPostfixes.call(this);
  this.styleDecoration.AddPostfix(ASPx.TEInputSuffix);
 },
 GetValue: function() {
  var value = null;
  if(this.maskInfo != null)
   value = this.maskInfo.GetValue();
  else if(this.HasTextDecorators())
   value = this.GetRawValue();
  else {
   var input = this.GetInputElement();
   value = input ? input.value : null;
  };
  return (value == "" && this.convertEmptyStringToNull) ? null : value;
 },
 SetValue: function(value) {
  if(value == null || value === undefined) 
   value = "";
  if(this.maskInfo != null) {
   this.maskInfo.SetValue(value.toString());
   this.ApplyMaskInfo(false);
   this.SavePrevMaskValue();
  } 
  else if(this.HasTextDecorators()) {
   this.SetRawValue(value);
   this.GetInputElement().value = this.CanApplyTextDecorators() && this.GetInputElement().type != "password" ? this.GetDecoratedText(value) : value;
  }
  else
   this.GetInputElement().value = value;
  if(this.styleDecoration)
   this.styleDecoration.Update();   
  this.SaveChangedValue();   
 },
 SetVisible: function(visible) {
  ASPxClientEdit.prototype.SetVisible.call(this, visible);
  if(this.helpTextDisplayMode === ASPxClientTextEditHelpTextDisplayMode.Inline) {
   if(visible)
    this.showHelpText();
   else
    this.hideHelpText();
  }
 },
 UnstretchInputElement: function(){
  var inputElement = this.GetInputElement();
  var mainElement = this.GetMainElement();
  var mainElementCurStyle = ASPx.GetCurrentStyle(mainElement);
  if(ASPx.IsExistsElement(mainElement) && ASPx.IsExistsElement(inputElement) && ASPx.IsExists(mainElementCurStyle) && 
   inputElement.style.width == "100%" &&
   (mainElementCurStyle.width == "" || mainElementCurStyle.width == "auto"))
   inputElement.style.width = "";
 },
 RestoreActiveElement: function(activeElement) {
  if(activeElement && activeElement.setActive && activeElement.tagName != "IFRAME")
   activeElement.setActive();
 },
 RaiseValueChangedEvent: function() {
  var processOnServer = ASPxClientEdit.prototype.RaiseValueChangedEvent.call(this);
  processOnServer = this.RaiseTextChanged(processOnServer);
  return processOnServer;
 },
 InitMask: function() {
  var rawValue = this.GetRawValue();
  this.SetValue(rawValue.length ? this.DecodeRawInputValue(rawValue) : this.maskInfo.GetValue());
  this.validationPatterns.unshift(new MaskValidationPattern(this.maskInfo.errorText, this.maskInfo));
 },
 SetMaskPasteTimer: function() {
  this.ClearMaskPasteTimer();
  this.maskPasteTimerID = ASPx.Timer.SetControlBoundInterval(this.MaskPasteTimerProc, this, ASPx.PasteCheckInterval);
 },
 ClearMaskPasteTimer: function() {
  this.maskPasteTimerID = ASPx.Timer.ClearInterval(this.maskPasteTimerID);
 },
 SavePrevMaskValue: function() {
  this.maskValueBeforeUserInput = this.maskInfo.GetValue();
 },
 FillMaskInfo: function() {
  var input = this.GetInputElement();
  if(!input) return; 
  var sel = ASPx.Selection.GetInfo(input);
  this.maskInfo.SetCaret(sel.startPos, sel.endPos - sel.startPos);  
 },
 ApplyMaskInfo: function(applyCaret) {
  this.SyncRawValue();
  var input = this.GetInputElement();
  var text = this.GetMaskDisplayText();
  this.maskTextBeforePaste = text;
  if(input.value != text)
   input.value = text;
  if(applyCaret)
   ASPx.Selection.Set(input, this.maskInfo.caretPos, this.maskInfo.caretPos + this.maskInfo.selectionLength);
 },
 GetMaskDisplayText: function() {
  if(!this.focused && this.HasTextDecorators())
   return this.GetDecoratedText(this.maskInfo.GetValue());
  return this.maskInfo.GetText();
 },
 ShouldCancelMaskKeyProcessing: function(htmlEvent, keyDownInfo) {
  return ASPx.Evt.IsEventPrevented(htmlEvent);
 }, 
 HandleMaskKeyDown: function(evt) {
  var keyInfo = ASPx.MaskManager.CreateKeyInfoByEvent(evt);
  ASPx.MaskManager.keyCancelled = this.ShouldCancelMaskKeyProcessing(evt, keyInfo);
  if(ASPx.MaskManager.keyCancelled) {
   ASPx.Evt.PreventEvent(evt);
   return;
  }
  this.maskPasteLock = true;
  this.FillMaskInfo();  
  var canHandle = ASPx.MaskManager.CanHandleControlKey(keyInfo);   
  ASPx.MaskManager.savedKeyDownKeyInfo = keyInfo;
  if(canHandle) {   
   ASPx.MaskManager.OnKeyDown(this.maskInfo, keyInfo);
   this.ApplyMaskInfo(true);
   ASPx.Evt.PreventEvent(evt);
  }
  ASPx.MaskManager.keyDownHandled = canHandle;
  this.maskPasteLock = false;
  this.UpdateMaskHintHtml();
 },
 HandleMaskKeyPress: function(evt) {
  var keyInfo = ASPx.MaskManager.CreateKeyInfoByEvent(evt);
  ASPx.MaskManager.keyCancelled = ASPx.MaskManager.keyCancelled || this.ShouldCancelMaskKeyProcessing(evt, ASPx.MaskManager.savedKeyDownKeyInfo);
  if(ASPx.MaskManager.keyCancelled) {
   ASPx.Evt.PreventEvent(evt);
   return;
  }
  this.maskPasteLock = true;  
  var printable = ASPx.MaskManager.savedKeyDownKeyInfo != null && ASPx.MaskManager.IsPrintableKeyCode(ASPx.MaskManager.savedKeyDownKeyInfo);
  if(printable) {
   ASPx.MaskManager.OnKeyPress(this.maskInfo, keyInfo);
   this.ApplyMaskInfo(true);
  }
  if(printable || ASPx.MaskManager.keyDownHandled)   
   ASPx.Evt.PreventEvent(evt); 
  this.maskPasteLock = false;
  this.UpdateMaskHintHtml();
 },
 MaskPasteTimerProc: function() {
  if(this.maskPasteLock || !this.maskInfo) return;
  this.maskPasteCounter++;
  var inputElement = this.inputElement;
  if(!inputElement || this.maskPasteCounter > 40) {
   this.maskPasteCounter = 0;
   inputElement = this.GetInputElement();
   if(!ASPx.IsExistsElement(inputElement)) {
    this.ClearMaskPasteTimer();
    return;
   }
  }
  if(this.maskTextBeforePaste !== inputElement.value) {
   this.maskInfo.ProcessPaste(inputElement.value, ASPx.Selection.GetInfo(inputElement).endPos);
   this.ApplyMaskInfo(true);
  }
  if(!this.focused)
   this.ClearMaskPasteTimer();
 },
 BeginShowMaskHint: function() {  
  if(!this.readOnly && this.maskHintTimerID == -1)
   this.maskHintTimerID = window.setInterval(ASPx.MaskHintTimerProc, 500);
 },
 EndShowMaskHint: function() {
  window.clearInterval(this.maskHintTimerID);
  this.maskHintTimerID = -1;
 },
 MaskHintTimerProc: function() {  
  if(this.maskInfo) {
   this.FillMaskInfo();
   this.UpdateMaskHintHtml();
  } else {
   this.EndShowMaskHint();
  }
 },
 UpdateMaskHintHtml: function() {  
  var hint =  this.GetMaskHintElement();
  if(!ASPx.IsExistsElement(hint))
   return;
  var html = ASPx.MaskManager.GetHintHtml(this.maskInfo);
  if(html == this.maskHintHtml)
   return;
  if(html != "") {
   var mainElement = this.GetMainElement();
   if(ASPx.IsExistsElement(mainElement)) {
    hint.innerHTML = html;
    hint.style.position = "absolute";  
    hint.style.left = ASPx.PrepareClientPosForElement(ASPx.GetAbsoluteX(mainElement), mainElement, true) + "px";
    hint.style.top = (ASPx.PrepareClientPosForElement(ASPx.GetAbsoluteY(mainElement), mainElement, false) + mainElement.offsetHeight + 2) + "px";
    hint.style.display = "block";    
   }   
  } else {
   hint.style.display = "none";
  }
  this.maskHintHtml = html;
 },
 HideMaskHint: function() {
  var hint =  this.GetMaskHintElement();
  if(ASPx.IsExistsElement(hint))
   hint.style.display = "none";
  this.maskHintHtml = "";
 },
 GetMaskHintElement: function() {
  return ASPx.GetElementById(this.name + "_MaskHint");
 },
 OnFocus: function() {
  if(this.maskInfo != null && !ASPx.GetControlCollection().InCallback())
   this.SetMaskPasteTimer();
  ASPxClientEdit.prototype.OnFocus.call(this);
 },
 OnMouseWheel: function(evt){
  if(this.readOnly || this.maskInfo == null) return;
  this.FillMaskInfo();
  ASPx.MaskManager.OnMouseWheel(this.maskInfo, ASPx.Evt.GetWheelDelta(evt) < 0 ? -1 : 1);
  this.ApplyMaskInfo(true);
  ASPx.Evt.PreventEvent(evt);
  this.UpdateMaskHintHtml();
 }, 
 OnBrowserWindowResize: function(e) {
  if(!this.autoResizeWithContainer)
   this.AdjustControl();
 },
 IsValueChanged: function() {
  return this.GetValue() != this.lastChangedValue; 
 },
 OnKeyDown: function(evt) {        
  if(this.NeedPreventBrowserUndoBehaviour(evt))
   return ASPx.Evt.PreventEvent(evt);
  if(this.RequireHandleMaxlenManually()) {
   this.onKeyDownInputValue = this.GetInputElement().value;
   var selectionInfo = ASPx.Selection.GetExtInfo(this.GetInputElement());
   this.onKeyDownCursorPos = selectionInfo.startPos;
  }
  if(ASPx.Browser.IE && ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Esc) {   
   if(++this.escCount > 1) {
    ASPx.Evt.PreventEvent(evt);
    return;
   }
  } else 
   this.escCount = 0;
  ASPxClientEdit.prototype.OnKeyDown.call(this, evt);
  if(!this.IsRaiseStandardOnChange(evt)) {
   if(!this.readOnly && this.maskInfo != null)
    this.HandleMaskKeyDown(evt);
  }
 },
 IsCtrlZ: function(evt) {
  return evt.ctrlKey && !evt.altKey && !evt.shiftKey && (ASPx.Evt.GetKeyCode(evt) == 122 || ASPx.Evt.GetKeyCode(evt) == 90)
 },
 NeedPreventBrowserUndoBehaviour: function(evt) {
  var inputElement = this.GetInputElement();
  return this.IsCtrlZ(evt) && !!inputElement && !inputElement.value;
 },
 OnKeyPress: function(evt) {
  ASPxClientEdit.prototype.OnKeyPress.call(this, evt);
  if(!this.readOnly && this.maskInfo != null && !this.IsRaiseStandardOnChange(evt))
   this.HandleMaskKeyPress(evt);
  if(this.NeedOnKeyEventEnd(evt, true))
   this.OnKeyEventEnd(evt);
 },
 OnKeyUp: function(evt) {
  if(ASPx.Browser.Firefox && !this.focused && ASPx.Evt.GetKeyCode(evt) === ASPx.Key.Tab)
   return;
  if(this.NeedOnKeyEventEnd(evt, false)) {
   var proccessNextCommingPress = ASPx.Evt.GetKeyCode(evt) === ASPx.Key.Alt; 
   this.OnKeyEventEnd(evt, proccessNextCommingPress);
  }
  if(this.RequireHandleMaxlenManually()) {
   var inputValueLength = this.GetInputElement().value.length;
   var maxLength = this.GetInputMaxLength();
   if(inputValueLength > maxLength && inputValueLength > this.onKeyDownInputValue.length) {
    this.GetInputElement().value = this.onKeyDownInputValue;
    this.SetCaretPosition(this.onKeyDownCursorPos);
   }
  }
  ASPxClientEdit.prototype.OnKeyUp.call(this, evt);
 },
 RequireHandleMaxlenManually: function() { 
  return ASPx.Browser.AndroidMobilePlatform && ASPx.Browser.SamsungAndroidDevice && ASPx.Browser.PlaformMajorVersion < 6 && this.GetInputMaxLength() !== -1;
 },
 GetInputMaxLength: function() {
  var input = this.GetInputElement();
  if(ASPx.Attr.IsExistsAttribute(input, "maxlength"))
   return input.maxLength;
  return -1;
 },
 NeedOnKeyEventEnd: function(evt, isKeyPress) { 
  var handleKeyPress = this.maskInfo != null && evt.keyCode == ASPx.Key.Enter;
  return handleKeyPress == isKeyPress;
 },
 OnKeyEventEnd: function(evt, withDelay){
  if(!this.readOnly) {
   if(this.IsRaiseStandardOnChange(evt))
    this.RaiseStandardOnChange();
   this.SyncRawValueIfHasTextDecorators(withDelay);
  }
 },
 SyncRawValueIfHasTextDecorators: function(withDelay) {
  if(this.HasTextDecorators()) {
   if(withDelay) {
    window.setTimeout(function() {
     this.SyncRawValue();
    }.aspxBind(this), 0);
   } else 
    this.SyncRawValue();
  }
 },
 IsRaiseStandardOnChange: function(evt){
  return !this.specialKeyboardHandlingUsed && this.raiseValueChangedOnEnter && evt.keyCode == ASPx.Key.Enter;
 },
 GetFocusSelectAction: function() {
  if(this.maskInfo)
   return "start";
  return "all"; 
 },
 CorrectFocusWhenDisabled: function() {
  if(!this.GetEnabled()) {
   var inputElement = this.GetInputElement();
   if(inputElement)
    inputElement.blur();
   return true;
  }
  return false;
 },
 EnsureShowPopupHelpText: function() {
  if(this.helpTextDisplayMode === ASPxClientTextEditHelpTextDisplayMode.Popup)
   this.showHelpText();
 },
 EnsureHidePopupHelpText: function() {
  if(this.helpTextDisplayMode === ASPxClientTextEditHelpTextDisplayMode.Popup)
   this.hideHelpText();
 },
 OnFocusCore: function() {
  if(this.CorrectFocusWhenDisabled())
   return;
  var wasLocked = this.IsFocusEventsLocked();
  ASPxClientEdit.prototype.OnFocusCore.call(this);
  this.CorrectInputMaxLength(true);
  if(this.maskInfo != null) {
   this.SavePrevMaskValue();
   this.BeginShowMaskHint();
   this.AttachOnMouseClickIfNeeded();
  }
  if(!wasLocked)
   this.ToggleTextDecoration();
  if(this.isPasswordNullTextInputElementExists())
   setTimeout(function() { this.EnsureShowPopupHelpText(); }.aspxBind(this), 0);
  else
   this.EnsureShowPopupHelpText();
 },
 clearMaskedEditorClickEventHandlers: function () {
  for(var i = 0; i < this.maskedEditorClickEventHandlers.length; i++)
   ASPx.Evt.DetachEventFromElement(this.GetInputElement(), "click", this.maskedEditorClickEventHandlers[i]);
  this.maskedEditorClickEventHandlers = [];
 },
 addMaskedEditorClickEventHandler: function () {
  this.maskedEditorClickEventHandlers.push(this.MouseClickOnMaskedEditorFunc);
  ASPx.Evt.AttachEventToElement(this.GetInputElement(), "click", this.MouseClickOnMaskedEditorFunc);
 },
 AttachOnMouseClickIfNeeded: function () {
  this.clearMaskedEditorClickEventHandlers();
  if(this.GetValue() == "" || this.GetValue() == null) {
   this.MouseClickOnMaskedEditorFunc = function (e) {
    this.clearMaskedEditorClickEventHandlers();
    var selectionInfo = ASPx.Selection.GetExtInfo(this.GetInputElement());
    if(selectionInfo.startPos == selectionInfo.endPos)
     this.SetCaretPosition(this.GetInitialCaretPositionInEmptyMaskedInput());
   }.aspxBind(this);
   this.addMaskedEditorClickEventHandler();
  }
 },
 GetInitialCaretPositionInEmptyMaskedInput: function() {
  var maskParts = this.maskInfo.parts;
  return ASPx.MaskManager.IsLiteralPart(maskParts[0]) ? maskParts[0].GetSize() : 0;
 },
 OnLostFocusCore: function() {
  var wasLocked = this.IsFocusEventsLocked();
  ASPxClientEdit.prototype.OnLostFocusCore.call(this);
  this.CorrectInputMaxLength();
  if(this.maskInfo != null) {
   this.EndShowMaskHint();
   this.HideMaskHint();   
   if(this.maskInfo.ApplyFixes(null))
    this.ApplyMaskInfo(false);
   this.RaiseStandardOnChange();
  }
  if(!wasLocked)
   this.ToggleTextDecoration();
  this.escCount = 0;
  this.EnsureHidePopupHelpText();
 },
 InputMaxLengthCorrectionRequired: function () {
  return ASPx.Browser.IE && ASPx.Browser.Version >= 10 && (!this.isNative || this.nullText != "");
 },
 CorrectInputMaxLength: function (onFocus) {
  if(this.InputMaxLengthCorrectionRequired()) {
   var input = this.GetInputElement();
   if(!ASPx.IsExists(this.inputMaxLength))
    this.inputMaxLength = input.maxLength;
   input.maxLength = onFocus ? this.inputMaxLength : -1;
  }
 },
 SubscribeToIeDropEvent: function() {
  if(this.InputMaxLengthCorrectionRequired()) {
   var input = this.GetInputElement();
   ASPx.Evt.AttachEventToElement(input, "drop", function(e) { this.CorrectInputMaxLength(true); }.aspxBind(this));
  }
 },
 SetFocus: function() {
  if(this.isPasswordNullTextInputElementExists()) {
   this.GetPasswordNullTextInputElement().focus();
  } else {
     ASPxClientEdit.prototype.SetFocus.call(this);
  }
 },
 OnValueChanged: function() {
  if(this.maskInfo != null) {
   if(this.maskInfo.GetValue() == this.maskValueBeforeUserInput && !this.IsValueChangeForced())
    return;
   this.SavePrevMaskValue();
  }
  if(this.HasTextDecorators())
   this.SyncRawValue();
  if(!this.IsValueChanged() && !this.IsValueChangeForced())
   return;
  this.SaveChangedValue(); 
  ASPxClientEdit.prototype.OnValueChanged.call(this);
 },
 IsValueChangeForced: function() {
  return false;
 },
 OnTextChanged: function() {
 },
 SaveChangedValue: function() {
  this.lastChangedValue = this.GetValue();
 },
 RaiseStandardOnChange: function(){
  var element = this.GetInputElement();
  if(element && element.onchange) {
   element.onchange({ target: this.GetInputElement() });
  }
  else if(this.ValueChanged) {
   this.ValueChanged.FireEvent(this);
  }
 },
 RaiseTextChanged: function(processOnServer){
  if(!this.TextChanged.IsEmpty()){
   var args = new ASPxClientProcessingModeEventArgs(processOnServer);
   this.TextChanged.FireEvent(this, args);
   processOnServer = args.processOnServer;
  }
  return processOnServer;  
 },
 GetText: function(){
  if(this.maskInfo != null) {
   return this.maskInfo.GetText();
  } else {
   var value = this.GetValue();
   return value != null ? value : "";
  }
 },
 SetText: function (value){
  if(this.maskInfo != null) {
   this.maskInfo.SetText(value);
   this.ApplyMaskInfo(false);
   this.SavePrevMaskValue();
  } else {
   this.SetValue(value);
  }
 },
 SelectAll: function() {
  this.SetSelection(0, -1, false);
 },
 SetCaretPosition: function(pos) {
  var inputElement = this.GetInputElement();
  ASPx.Selection.SetCaretPosition(inputElement, pos);
 },
 SetSelection: function(startPos, endPos, scrollToSelection) { 
  var inputElement = this.GetInputElement();
  ASPx.Selection.Set(inputElement, startPos, endPos, scrollToSelection);
 },
 ChangeEnabledAttributes: function(enabled){
  var inputElement = this.GetInputElement();
  if(inputElement){
   this.ChangeInputEnabledAttributes(inputElement, ASPx.Attr.ChangeAttributesMethod(enabled), enabled);
   if(this.specialKeyboardHandlingUsed)
    this.ChangeSpecialInputEnabledAttributes(inputElement, ASPx.Attr.ChangeEventsMethod(enabled));
   this.ChangeInputEnabled(inputElement, enabled, this.readOnly);
  }
 },
 ChangeEnabledStateItems: function(enabled){
  if(!this.isNative) {
   var sc = ASPx.GetStateController();
   sc.SetElementEnabled(this.GetMainElement(), enabled);
   sc.SetElementEnabled(this.GetInputElement(), enabled);
  }
 },
 ChangeInputEnabled: function(element, enabled, readOnly) {
  if(this.UseReadOnlyForDisabled())
   element.readOnly = !enabled || readOnly;
  else
   element.disabled = !enabled;
 },
 ChangeInputEnabledAttributes: function(element, method, enabled) {
  var ieTabIndexFix = enabled && ASPx.Browser.IE && element.setAttribute && ASPx.Attr.IsExistsAttribute(element, "savedtabIndex");
  method(element, "tabIndex");
  if(!enabled) element.tabIndex = -1;
  if(ieTabIndexFix) { 
   window.setTimeout(function() {
    if(element && element.parentNode)
     element.parentNode.replaceChild(element, element); 
   }, 0);
  }
  method(element, "onclick");
  if(!this.NeedFocusCorrectionWhenDisabled())
   method(element, "onfocus");
  method(element, "onblur");
  method(element, "onkeydown");
  method(element, "onkeypress");
  method(element, "onkeyup");
 },
 UseReadOnlyForDisabled: function() {
  return (ASPx.Browser.IE && ASPx.Browser.Version < 10) && !this.isNative;
 },
 NeedFocusCorrectionWhenDisabled: function(){
  return (ASPx.Browser.IE && ASPx.Browser.Version < 10) && !this.isNative;
 },
 OnPostFinalization: function(args) {
  if(this.GetEnabled() || !this.UseReadOnlyForDisabled() || args.isDXCallback)
   return;
  var inputElement = this.GetInputElement();
  if(inputElement) {
   var inputDisabled = inputElement.disabled;
   inputElement.disabled = true;
   window.setTimeout(function() {
    inputElement.disabled = inputDisabled;
   }.aspxBind(this), 0);
  }
 }
});
MaskValidationPattern = ASPx.CreateClass(ASPx.ValidationPattern, {
 constructor: function(errorText, maskInfo) {
  this.constructor.prototype.constructor.call(this, errorText);
  this.maskInfo = maskInfo;
 },
 EvaluateIsValid: function(value) {
  return this.maskInfo.IsValid();
 }
});
ASPx.Ident.IsASPxClientTextEdit = function(obj) {
 return !!obj.isASPxClientTextEdit;
};
var ASPxClientTextBoxBase = ASPx.CreateClass(ASPxClientTextEdit, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.sizingConfig.allowSetHeight = false;
  this.sizingConfig.adjustControl = true;
 }
});
var ASPxClientTextBox = ASPx.CreateClass(ASPxClientTextBoxBase, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.isASPxClientTextBox = true;
 }
});
ASPxClientTextBox.Cast = ASPxClientControl.Cast;
ASPx.Ident.IsASPxClientTextBox = function(obj) {
 return !!obj.isASPxClientTextBox;
};
var ASPxClientMemo = ASPx.CreateClass(ASPxClientTextEdit, { 
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);        
  this.isASPxClientMemo = true;
  this.raiseValueChangedOnEnter = false;
  this.maxLength = 0;
  this.pasteTimerID = -1;
  this.pasteTimerActivatorCount = 0;
 },
 Initialize: function() {
  ASPxClientTextEdit.prototype.Initialize.call(this);
  this.SaveChangedValue();
  this.maxLengthRestricted = this.maxLength > 0;
 },
 CutString: function() {
  var text = this.GetText();
  if(text.length > this.maxLength) {
   text = text.substring(0, this.maxLength);
   this.SetText(text);
  }
 },
 EventKeyCodeChangesTheInput: function(evt) {
  if(ASPx.IsPasteShortcut(evt))
   return true;
  else if(evt.ctrlKey)
   return false;
  var keyCode = ASPx.Evt.GetKeyCode(evt);
  var isSystemKey = ASPx.Key.Windows <= keyCode && keyCode <= ASPx.Key.ContextMenu;
  var isFKey = ASPx.Key.F1 <= keyCode && keyCode <= 127; 
  return ASPx.Key.Delete < keyCode && !isSystemKey && !isFKey || keyCode == ASPx.Key.Enter || keyCode == ASPx.Key.Space;
 },
 OnTextChangingCheck: function() {
  if(this.maxLengthRestricted)  
   this.CutString(); 
 },
 StartTextChangingTimer: function() {
  if(this.maxLengthRestricted) {
   if(this.pasteTimerActivatorCount == 0) 
    this.SetTextChangingTimer();
   this.pasteTimerActivatorCount ++;
  }
 },
 EndTextChangingTimer: function() {
  if(this.maxLengthRestricted) {
   this.pasteTimerActivatorCount --;
   if(this.pasteTimerActivatorCount == 0) 
    this.ClearTextChangingTimer();
  }
 },
 CollapseEditor: function() {
  if(!this.IsAdjustmentRequired()) return;
  var mainElement = this.GetMainElement();
  var inputElement = this.GetInputElement();
  if(!ASPx.IsExistsElement(mainElement) || !ASPx.IsExistsElement(inputElement))
   return;
  ASPxClientTextEdit.prototype.CollapseEditor.call(this);
  var mainElementCurStyle = ASPx.GetCurrentStyle(mainElement);
  if(this.heightCorrectionRequired && mainElement && inputElement) {
   if(mainElement.style.height == "100%" || mainElementCurStyle.height == "100%") {
    mainElement.style.height = "0";
    mainElement.wasCollapsed = true;
   }
   inputElement.style.height = "0";
  }
 },
 CorrectEditorHeight: function() {
  var mainElement = this.GetMainElement();
  if(mainElement.wasCollapsed) {
   mainElement.wasCollapsed = null;
   ASPx.SetOffsetHeight(mainElement, ASPx.GetClearClientHeight(ASPx.FindOffsetParent(mainElement)));
  }
  if(!this.isNative) {
   var inputElement = this.GetInputElement();
   var inputClearClientHeight = ASPx.GetClearClientHeight(ASPx.FindOffsetParent(inputElement));
   if(ASPx.Browser.IE) {
    inputClearClientHeight -= 2;
    var calculatedMainElementStyle = ASPx.GetCurrentStyle(mainElement);
    inputClearClientHeight += ASPx.PxToInt(calculatedMainElementStyle.borderTopWidth) + ASPx.PxToInt(calculatedMainElementStyle.borderBottomWidth);
   }
   if(inputClearClientHeight < memoMinHeight)
    inputClearClientHeight = memoMinHeight;
   ASPx.SetOffsetHeight(inputElement, inputClearClientHeight);
   mainElement.style.height = "100%";
   setTimeout(function() {
    var inputParentOffsetHeight = ASPx.GetClearClientHeight(ASPx.FindOffsetParent(inputElement));
    if(inputParentOffsetHeight != inputClearClientHeight) {
      ASPx.SetOffsetHeight(inputElement, inputParentOffsetHeight); 
     }
   }, 0);
  }
 },
 SetWidth: function(width) {
  ASPxClientTextEdit.prototype.SetWidth.call(this, width);
  if(ASPx.Browser.IE)
   this.AdjustControl();
 },
 SetHeight: function(height) {
  var textarea = this.GetInputElement();
  textarea.style.height = "1px";
  ASPxClientTextEdit.prototype.SetHeight.call(this, height);
  textarea.style.height = ASPx.GetClearClientHeight(this.GetMainElement()) - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(textarea) + "px";
 },
 ClearErrorFrameElementsStyles: function() {
  var textarea = this.GetInputElement();
  if(!textarea)
   return;
  var scrollBarPosition = textarea.scrollTop;
  ASPxClientTextEdit.prototype.ClearErrorFrameElementsStyles.call(this);
  if(ASPx.Browser.Firefox)
   textarea.scrollTop = scrollBarPosition;
 },
 OnMouseOver: function() {
  this.StartTextChangingTimer();
 },  
 OnMouseOut: function() {
  this.EndTextChangingTimer();
 },   
 OnFocus: function() {  
  this.StartTextChangingTimer();
  ASPxClientEdit.prototype.OnFocus.call(this);
 },
 OnLostFocus: function() {
  this.EndTextChangingTimer();
  ASPxClientEdit.prototype.OnLostFocus.call(this);
 },
 OnKeyDown: function(evt) { 
  if(this.NeedPreventBrowserUndoBehaviour(evt))
   return ASPx.Evt.PreventEvent(evt);
  if(this.maxLengthRestricted){
   var selection = ASPx.Selection.GetInfo(this.GetInputElement()); 
   var noCharToReplace = selection.startPos == selection.endPos;
   if(this.GetText().length >= this.maxLength && noCharToReplace && this.EventKeyCodeChangesTheInput(evt)) {
    return ASPx.Evt.PreventEvent(evt);
   }
  }
  ASPxClientEdit.prototype.OnKeyDown.call(this, evt);
 },
 SetTextChangingTimer: function() {
  this.pasteTimerID = ASPx.Timer.SetControlBoundInterval(this.OnTextChangingCheck, this, ASPx.PasteCheckInterval);
 },
 ClearTextChangingTimer: function() {
  this.pasteTimerID = ASPx.Timer.ClearInterval(this.pasteTimerID);
 }
});
ASPxClientMemo.Cast = ASPxClientControl.Cast;
ASPx.Ident.IsASPxClientMemo = function(obj) { return obj && !!obj.isASPxClientMemo; };
var CLEAR_BUTTON_INDEX = -100;
var HIDE_CONTENT_CSS_CLASS_NAME = "dxHideContent";
var setContentVisibility = function(clearButtonElement, value) {
 var action = value ? ASPx.RemoveClassNameFromElement : ASPx.AddClassNameToElement;
 action(clearButtonElement, HIDE_CONTENT_CSS_CLASS_NAME);
};
var CLEAR_BUTTON_DISPLAY_MODE = {
 AUTO: 'Auto',
 ALWAYS: 'Always',
 NEVER: 'Never',
 ON_HOVER: 'OnHover'
};
var AccessibilityFocusedButtonClassName = "dxAFB";
var ASPxClientButtonEditBase = ASPx.CreateClass(ASPxClientTextBoxBase, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);        
  this.allowUserInput = true;
  this.isValueChanging = false;
  this.allowMouseWheel = true;
  this.isMouseOver = false;
  this.buttonCount = 0;
  this.emptyValueMaskDisplayText = "";
  this.clearButtonDisplayMode = CLEAR_BUTTON_DISPLAY_MODE.AUTO;
  this.forceShowClearButtonAlways = false;
  this.recoverClearButtonVisibility = false;
  this.ButtonClick = new ASPxClientEvent();
 },
 Initialize: function() {
  ASPxClientTextBoxBase.prototype.Initialize.call(this);
  this.EnsureEmptyValueMaskDisplayText();
  if(this.HasClearButton())
   this.InitializeClearButton();
  this.InitAccessibilityCompliant();
 },
 InlineInitialize: function() {
  ASPxClientTextBoxBase.prototype.InlineInitialize.call(this);
  if(this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.AUTO) {
   this.clearButtonDisplayMode = this.IsClearButtonVisibleAuto() || this.forceShowClearButtonAlways ?
    CLEAR_BUTTON_DISPLAY_MODE.ALWAYS : CLEAR_BUTTON_DISPLAY_MODE.NEVER;
  }
  this.EnsureClearButtonVisibility();
 },
 InitializeClearButton: function() {
  if(this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.ON_HOVER) {
   ASPx.Evt.AttachMouseEnterToElement(this.GetHoverElementToShowClearButton(), this.OnMouseOver.aspxBind(this), this.OnMouseOut.aspxBind(this));
  }
 },
 GetHoverElementToShowClearButton: function() {
  return this.GetMainElement();
 },
 IsClearButtonVisibleAuto: function() {
  return ASPx.Browser.MobileUI;
 },
 EnsureEmptyValueMaskDisplayText: function() {
  if(this.maskInfo && this.HasClearButton()) {
   var savedText = this.maskInfo.GetText();
   this.maskInfo.SetText("");
   this.emptyValueMaskDisplayText = this.maskInfo.GetText();
   this.maskInfo.SetText(savedText);
  }
 },
 GetButton: function(number) {
  return this.GetChildElement("B" + number);
 },
 GetCustomButtonCollection: function() {
  var buttonElements = [];
  for(var i = 0; i < this.buttonCount; i++) {
   var button =  this.GetButton(i);
   if(!!button)
    buttonElements.push(button);
  }
  return buttonElements;
 },
 GetButtonCollection: function() {
  var buttonElements = [];
  var clearButton = this.GetClearButton();
  if(!!clearButton)
   buttonElements.push(clearButton);
  return buttonElements.concat(this.GetCustomButtonCollection());
 },
 GetAccessibilityAnchor: function(buttonElement) {
  var firstChild = buttonElement.firstElementChild;
  var isExistsAnchorElement = ASPx.Attr.GetAttribute(firstChild, "role") === "button";
  return isExistsAnchorElement ? firstChild : null;
 },
 GetButtonByAccessibilityAnchor: function(anchorElement) {
  return anchorElement.parentNode;
 },
 SetAccessibilityAnchorEnabled: function(buttonElement, enabled) {
  var anchorElement = this.GetAccessibilityAnchor(buttonElement);
  if(ASPx.IsExists(anchorElement))
   ASPx.Attr.SetOrRemoveAttribute(anchorElement, "tabindex", enabled ? "0" : "");
 },
 InitAccessibilityCompliant: function() {
  if(!this.accessibilityCompliant) return;
  var buttonElements = this.GetButtonCollection();
  var labelElements = ASPx.FindAssociatedLabelElements(this);
  for(var i = 0; i < buttonElements.length; i++)
   this.InitAccessibilityAnchor(this.GetAccessibilityAnchor(buttonElements[i]), labelElements);     
 },
 InitAccessibilityAnchor: function(anchorElement, labelElements) {
  if(!ASPx.IsExists(anchorElement))
   return;
  for(var i = 0; i < labelElements.length; i++)
   this.ariaExplanatoryTextManager.SetOrRemoveText([anchorElement], labelElements[i], true, false, false);
  this.InitAccessibilityAnchorEvents(anchorElement);
 },
 InitAccessibilityAnchorEvents: function(anchorElement) {
  ASPx.Evt.AttachEventToElement(anchorElement, "keydown", function(evt) { this.OnButtonKeysHandling(evt); }.aspxBind(this));
  ASPx.Evt.AttachEventToElement(anchorElement, "keyup", function(evt) { this.OnButtonKeysHandling(evt); }.aspxBind(this));
  ASPx.Evt.AttachEventToElement(anchorElement, "focus", function(evt) { this.OnButtonGotFocus(evt); }.aspxBind(this));
  ASPx.Evt.AttachEventToElement(anchorElement, "blur", function(evt) { this.OnButtonLostFocus(evt); }.aspxBind(this));
 },
 EmulateButtonMouseEvent: function(sourceElement) {
  var buttonElement = this.GetButtonByAccessibilityAnchor(sourceElement);
  var mouseEvent = buttonElement.onclick || buttonElement.onmousedown || buttonElement.ontouchstart || buttonElement.onpointerdown;
  var emulateMouseEvtArgs = { button: 0, which: 1, srcElement: buttonElement, target: buttonElement };
  if(!!mouseEvent) {
   ASPx.Attr.SetAttribute(sourceElement, "aria-pressed", true);
   setTimeout(function() {
    mouseEvent(emulateMouseEvtArgs);
    ASPx.Attr.RemoveAttribute(sourceElement, "aria-pressed");
   }, 300);
  }
 },
 OnButtonKeysHandling: function(evt) {
  var isKeyUp = evt.type == "keyup";
  var keyCode = ASPx.Evt.GetKeyCode(evt);
  var sourceElement = ASPx.Evt.GetEventSource(evt);
  if((keyCode == ASPx.Key.Space && isKeyUp) || (keyCode == ASPx.Key.Enter && !isKeyUp))
   this.EmulateButtonMouseEvent(sourceElement);
  if(keyCode != ASPx.Key.Tab) {
   evt.cancelBubble = true;
   evt.preventDefault();
  }
  return false;
 },
 OnButtonGotFocus: function(evt) {
  var editor = ASPx.GetControlCollection().Get(this.name);
  var sourceElement = ASPx.Evt.GetEventSource(evt);
  if(!!editor && !editor.CorrectAccessibilityButtonFocus(sourceElement)) {
   var buttonElement = editor.GetButtonByAccessibilityAnchor(sourceElement);
   ASPx.AddClassNameToElement(buttonElement, this.GetAccessibilityFocusedButtonClassName());
   ASPx.EGotFocus(editor.name);
   if(editor.specialKeyboardHandlingUsed)
    ASPx.ESGotFocus(editor.name);
  }
 },
 OnButtonLostFocus: function(evt) {
  var editor = ASPx.GetControlCollection().Get(this.name);
  var sourceElement = ASPx.Evt.GetEventSource(evt);
  if(!!editor) {
   var buttonElement = editor.GetButtonByAccessibilityAnchor(sourceElement);
   ASPx.RemoveClassNameFromElement(buttonElement, this.GetAccessibilityFocusedButtonClassName());
  }
  setTimeout(function() {
   if(!!editor && !editor.IsEditorElement(ASPx.GetActiveElement())) {
    ASPx.ELostFocus(editor.name);
    if(editor.specialKeyboardHandlingUsed)
     ASPx.ESLostFocus(editor.name);
   }
  }.aspxBind(this), 0);
 },
 ForceRefocusEditor: function(evt, isNativeFocus) {
  if(this.accessibilityCompliant) {
   var srcElement = ASPx.Evt.GetEventSource(evt);
   var customButtons = this.GetCustomButtonCollection();
   for(var i = 0; i < customButtons.length; i++)
    if(customButtons[i] == srcElement || ASPx.GetIsParent(customButtons[i], srcElement))
     return;
  }
  ASPxClientEdit.prototype.ForceRefocusEditor.call(this, evt, isNativeFocus);
 },
 CorrectAccessibilityButtonFocus: function(sourceElement) {
  if(ASPx.Attr.IsExistsAttribute(sourceElement, "tabindex"))
   return false;
  setTimeout(function() {
   var buttonElements = this.GetButtonCollection();
   for(var i = 0; i < buttonElements.length; i++)
    if(ASPx.GetIsParent(buttonElements[i], sourceElement))
     this.GetAccessibilityAnchor(buttonElements[i]).focus();
  }.aspxBind(this), 0);
  return true;
 },
 OnKeyDown: function(evt) { 
  if(this.NeedEnsureClearButtonVisibilityOnKeyDown()) {
   var hasClearButtonOnHover = this.HasClearButton() && this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.ON_HOVER;
   this.recoverClearButtonVisibility = hasClearButtonOnHover && ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Tab && !evt.shiftKey;
  }
  ASPxClientTextBoxBase.prototype.OnKeyDown.call(this, evt);
 },
 NeedEnsureClearButtonVisibilityOnKeyDown: function() {
  return this.accessibilityCompliant;
 },
 GetAccessibilityFocusedButtonClassName: function() {
  return AccessibilityFocusedButtonClassName;
 },
 SetButtonVisible: function(number, value) {
  var button = this.GetButton(number);
  if(!button)
   return;
  var isAlwaysShownClearButton = number === CLEAR_BUTTON_INDEX && this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.ALWAYS;
  var visibilityModifier = isAlwaysShownClearButton ? this.GetClearButtonVisibilityModifier() : ASPx.SetElementDisplay;
  if(isAlwaysShownClearButton && this.accessibilityCompliant)
   this.SetAccessibilityAnchorEnabled(button, value);
  visibilityModifier(button, value);
 },
 GetButtonVisible: function(number) {
  var button = this.GetButton(number);
  if(number === CLEAR_BUTTON_INDEX && this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.ALWAYS)
   return button && !ASPx.ElementHasCssClass(button, this.GetHideContentCssClassName());
  return button && ASPx.IsElementVisible(button);
 },
 GetClearButtonVisibilityModifier: function() {
  return setContentVisibility;
 },
 GetHideContentCssClassName: function() {
  return HIDE_CONTENT_CSS_CLASS_NAME;
 },
 ProcessInternalButtonClick: function(buttonIndex) {
  return false;
 },
 OnButtonClick: function(number) {
  var processOnServer = this.RaiseButtonClick(number);
  if(!this.ProcessInternalButtonClick(number) && processOnServer)
   this.SendPostBack('BC:' + number);
 },
 GetLastSuccesfullValue: function() {
  return this.lastChangedValue;
 },
 OnClear: function() {
  this.ClearEditorValueAndForceOnChange();
  this.ForceRefocusEditor(null, true);
  window.setTimeout(this.EnsureClearButtonVisibility.aspxBind(this), 0);
 },
 ClearEditorValueAndForceOnChange: function() {
  if(this.readOnly || !this.GetButtonVisible(CLEAR_BUTTON_INDEX))
   return;
  var raiseOnChange = this.ClearEditorValueByClearButton();
  if(raiseOnChange)
   this.ForceStandardOnChange();
 },
 ClearEditorValueByClearButton: function() {
  var prevValue = this.GetLastSuccesfullValue();
  this.ClearEditorValueByClearButtonCore();
  return prevValue !== this.GetValue();
 },
 ClearEditorValueByClearButtonCore: function() {
  this.Clear();
  this.GetInputElement().value = '';
 },
 ForceStandardOnChange: function() {
  this.forceValueChanged = true;
  this.RaiseStandardOnChange();
  this.forceValueChanged = false;
 },
 IsValueChangeForced: function() {
  return this.forceValueChanged || ASPxClientTextBoxBase.prototype.IsValueChangeForced.call(this);
 },
 IsValueChanging: function() { return this.isValueChanging; },
 StartValueChanging: function() { this.isValueChanging = true; },
 EndValueChanging: function() { this.isValueChanging = false; },
 IsClearButtonElement: function(element) {
  return ASPx.GetIsParent(this.GetClearButton(), element);
 },
 OnFocusCore: function() {
  ASPxClientTextBoxBase.prototype.OnFocusCore.call(this);
  this.EnsureClearButtonVisibility();
 },
 OnLostFocusCore: function() {
  ASPxClientTextBoxBase.prototype.OnLostFocusCore.call(this);
  this.EnsureClearButtonVisibility();
  this.recoverClearButtonVisibility = false;
 },
 GetClearButton: function() {
  return this.GetButton(CLEAR_BUTTON_INDEX);
 },
 HasClearButton: function() {
  return !!this.GetClearButton();
 },
 RequireShowClearButton: function() {
  return !this.IsClearButtonDisabled() && !this.IsClearButtonNotRequired() && this.RequireShowClearButtonInternal();
 },
 IsClearButtonDisabled: function() {
  return !this.clientEnabled || !this.HasClearButton() || this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.NEVER;
 },
 IsClearButtonNotRequired: function() {
  return !this.IsFocused() && !this.isMouseOver && this.clearButtonDisplayMode !== CLEAR_BUTTON_DISPLAY_MODE.ALWAYS && !this.recoverClearButtonVisibility;
 },
 RequireShowClearButtonInternal: function () {
  if (this.IsFocused())
   return this.RequireShowClearButtonCore();
  return !this.IsNullState();
 },
 RequireShowClearButtonCore: function() {
  var inputText = this.GetInputElement().value;
  return inputText !== this.GetEmptyValueDisplayText();
 },
 IsFocused: function() {
  return this === ASPx.GetFocusedEditor();
 },
 IsNullState: function() {
  return this.IsNull(this.GetValue());
 },
 GetEmptyValueDisplayText: function() { 
  return this.maskInfo ? this.emptyValueMaskDisplayText : "";
 },
 EnsureClearButtonVisibility: function() {
  this.SetButtonVisible(CLEAR_BUTTON_INDEX, this.RequireShowClearButton());
 },
 OnMouseOver: function() {
  this.isMouseOver = true;
  this.EnsureClearButtonVisibility();
 },
 OnMouseOut: function() {
  this.isMouseOver = false;
  this.EnsureClearButtonVisibility();
 },
 OnKeyPress: function(evt) {
  if(this.allowUserInput)
   ASPxClientTextBoxBase.prototype.OnKeyPress.call(this, evt);
 },
 OnKeyEventEnd: function(evt, withDelay) {
  ASPxClientTextBoxBase.prototype.OnKeyEventEnd.call(this, evt, withDelay);
  this.EnsureClearButtonVisibility();
 },
 RaiseButtonClick: function(number){
  var processOnServer = this.autoPostBack || this.IsServerEventAssigned("ButtonClick");
  if(!this.ButtonClick.IsEmpty()){
   var args = new ASPxClientButtonEditClickEventArgs(processOnServer, number);
   this.ButtonClick.FireEvent(this, args);
   processOnServer = args.processOnServer;
  }
  return processOnServer;
 },
 ChangeEnabledAttributes: function(enabled){
  ASPxClientTextEdit.prototype.ChangeEnabledAttributes.call(this, enabled);
  for(var i = 0; i < this.buttonCount; i++){
   var element = this.GetButton(i);
   if(element)
    this.ChangeButtonEnabledAttributes(element, this.GetChangeButtonEnabledAttributesMethod(enabled));
  }
  if(this.accessibilityCompliant)
   this.ChangeAccessibilityButtonEnabledAttributes(enabled);
 },
 ChangeEnabledStateItems: function(enabled){
  ASPxClientTextEdit.prototype.ChangeEnabledStateItems.call(this, enabled);
  for(var i = 0; i < this.buttonCount; i++){
   var element = this.GetButton(i);
   if(element) 
    ASPx.GetStateController().SetElementEnabled(element, enabled);
  }
 },
 GetChangeButtonEnabledAttributesMethod: function(enabled) {
  return ASPx.Attr.ChangeAttributesMethod(enabled);
 },
 ChangeButtonEnabledAttributes: function(element, method){
  method(element, "onclick");
  method(element, "ondblclick");
  if(ASPx.Browser.Edge)
   method(element, "onmousedown");
  method(element, "on" + ASPx.TouchUIHelper.touchMouseDownEventName);
  method(element, "on" + ASPx.TouchUIHelper.touchMouseUpEventName);
 },
 ChangeInputEnabled: function(element, enabled, readOnly) {
  ASPxClientTextEdit.prototype.ChangeInputEnabled.call(this, element, enabled, readOnly || !this.allowUserInput);
 },
 ChangeAccessibilityButtonEnabledAttributes: function(enabled) {
  var buttonElements = this.GetButtonCollection();
  for(var i = 0; i < buttonElements.length; i++)
   this.SetAccessibilityAnchorEnabled(buttonElements[i], enabled);
 },
 SetValue: function(value) {
  ASPxClientTextEdit.prototype.SetValue.call(this, value);
  if(!this.IsFocused())
   this.EnsureClearButtonVisibility();
 },
 OnAssociatedLabelClick: function(focusableElement) {
  var isValidElement = focusableElement && ASPx.IsActionElement(focusableElement) && ASPx.GetIsParent(this.GetMainElement(), focusableElement) && ASPx.IsElementVisible(focusableElement);
  if(isValidElement)
   focusableElement.focus();
  else
   this.SetFocus();
 }
});
var ASPxClientButtonEdit = ASPx.CreateClass(ASPxClientButtonEditBase, {
});
ASPxClientButtonEdit.Cast = ASPxClientControl.Cast;
var ASPxClientButtonEditClickEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(processOnServer, buttonIndex){
  this.constructor.prototype.constructor.call(this, processOnServer);
  this.buttonIndex = buttonIndex;
 }
});
var ASPxClientTextEditHelpTextHAlign = {
 Left: "Left",
 Right: "Right",
 Center: "Center"
};
var ASPxClientTextEditHelpTextVAlign = {
 Top: "Top",
 Bottom: "Bottom",
 Middle: "Middle"
};
var ASPxClientTextEditHelpTextDisplayMode = {
 Inline: "Inline",
 Popup: "Popup"
};
var ASPxClientTextEditHelpTextConsts = {
 VERTICAL_ORIENTATION_CLASS_NAME: "dxeVHelpTextSys",
 HORIZONTAL_ORIENTATION_CLASS_NAME: "dxeHHelpTextSys"
};
var ASPxClientTextEditHelpText = ASPx.CreateClass(null, {
 constructor: function (editor, helpTextStyle, helpText, position, hAlign, vAlign, margins, animationEnabled, helpTextDisplayMode) {
  this.hAlign = hAlign;
  this.vAlign = vAlign;
  this.animationEnabled = animationEnabled;
  this.displayMode = helpTextDisplayMode;
  this.editor = editor;
  this.editorMainElement = editor.GetMainElement();
  this.margins = margins ? { Top: margins[0], Right: margins[1], Bottom: margins[2], Left: margins[3] } : null;
  this.defaultMargins = { Top: 10, Right: 10, Bottom: 10, Left: 10 };
  this.position = position;
  this.helpTextElement = this.createHelpTextElement();
  this.setHelpTextZIndex(true);
  this.prepareHelpTextElement(helpTextStyle, helpText);
 },
 getRows: function (table) {
  return ASPx.GetChildNodesByTagName(table, "TR");
 },
 getCells: function (row) {
  return ASPx.GetChildNodesByTagName(row, "TD");
 },
 getCellByIndex: function(row, cellIndex) {
  return this.getCells(row)[cellIndex];
 },
 getCellIndex: function(row, cell) {
  var cells = this.getCells(row);
  for(var i = 0; i < cells.length; i++) {
   if(cells[i] === cell)
    return i;
  }
 },
 isHorizontal: function(position) {
  return position === ASPx.Position.Left || position === ASPx.Position.Right;
 },
 isVertical: function (position) {
  return position === ASPx.Position.Top || position === ASPx.Position.Bottom;
 },
 createEmptyCell: function(assignClassName) {
  var cell = document.createElement("TD");
  if(assignClassName)
   cell.className = "dxeFakeEmptyCell";
  return cell;
 },
 addHelpTextCellToExternalTableWithTwoCells: function (captionCell, errorCell, helpTextCell, errorTableBody, tableRows) {
  var captionPosition = this.editor.captionPosition;
  var errorCellPosition = this.editor.errorCellPosition;
  var helpTextRow = this.isVertical(this.position) ? document.createElement("TR") : null;
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Left && this.isHorizontal(errorCellPosition))
   captionCell.parentNode.insertBefore(helpTextCell, captionCell.nextSibling);
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Right && this.isHorizontal(errorCellPosition))
   captionCell.parentNode.insertBefore(helpTextCell, captionCell);
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Right && this.isHorizontal(errorCellPosition))
   tableRows[0].appendChild(helpTextCell);
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Left && this.isHorizontal(errorCellPosition))
   tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
  if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Bottom && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.appendChild(helpTextRow);
  }
  if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, captionCell.parentNode.nextSibling);
  }
  if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Bottom && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, captionCell.parentNode);
  }
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   helpTextRow.appendChild(this.createEmptyCell());
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(this.position === ASPx.Position.Bottom) {
   if(captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Top || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Right) {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell());
    errorTableBody.appendChild(helpTextRow);
   }
  }
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(this.createEmptyCell());
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Bottom && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(this.createEmptyCell());
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.appendChild(helpTextRow);
  }
  if(this.position === ASPx.Position.Right) {
   if(captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Left || captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Top
    || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Right) {
    tableRows[1].appendChild(helpTextCell);
    tableRows[0].appendChild(this.createEmptyCell());
   }
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Bottom || captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Left) {
    tableRows[0].appendChild(helpTextCell);
    tableRows[1].appendChild(this.createEmptyCell());
   }
  }
  if(this.position === ASPx.Position.Left) {
   if(captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Top || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Right
    || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Left) {
    tableRows[1].insertBefore(helpTextCell, tableRows[1].childNodes[0]);
    tableRows[0].insertBefore(this.createEmptyCell(), tableRows[0].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Top || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Bottom) {
    tableRows[1].insertBefore(helpTextCell, tableRows[1].childNodes[0]);
    tableRows[0].insertBefore(this.createEmptyCell(errorCellPosition === ASPx.Position.Top), tableRows[0].childNodes[0]);
    tableRows[2].insertBefore(this.createEmptyCell(errorCellPosition !== ASPx.Position.Top), tableRows[2].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Top) {
    tableRows[2].insertBefore(helpTextCell, tableRows[2].childNodes[0]);
    tableRows[0].insertBefore(this.createEmptyCell(false), tableRows[0].childNodes[0]);
    tableRows[1].insertBefore(this.createEmptyCell(true), tableRows[1].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Bottom) {
    tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
    tableRows[1].insertBefore(this.createEmptyCell(true), tableRows[1].childNodes[0]);
    tableRows[2].insertBefore(this.createEmptyCell(false), tableRows[2].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Left || captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Bottom
    || captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Right) {
    tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
    tableRows[1].insertBefore(this.createEmptyCell(), tableRows[1].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Left && this.isVertical(errorCellPosition)) {
    captionCell.parentNode.insertBefore(helpTextCell, captionCell.nextSibling);
    var emptyCellParentRow = errorCellPosition === ASPx.Position.Top ? tableRows[0] : tableRows[1];
    var helpTextCellIndex = this.getCellIndex(helpTextCell.parentNode, helpTextCell);
    emptyCellParentRow.insertBefore(this.createEmptyCell(), this.getCellByIndex(emptyCellParentRow, helpTextCellIndex));
   }
  }
  if(this.position === ASPx.Position.Right) {
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Top || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Bottom) {
    tableRows[1].appendChild(helpTextCell);
    tableRows[0].appendChild(this.createEmptyCell(errorCellPosition === ASPx.Position.Top));
    tableRows[2].appendChild(this.createEmptyCell(errorCellPosition !== ASPx.Position.Top));
   }
   if(captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Top) {
    tableRows[2].appendChild(helpTextCell);
    tableRows[0].appendChild(this.createEmptyCell(false));
    tableRows[1].appendChild(this.createEmptyCell(true));
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Bottom) {
    tableRows[0].appendChild(helpTextCell);
    tableRows[1].appendChild(this.createEmptyCell(true));
    tableRows[2].appendChild(this.createEmptyCell(false));
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Right) {
    tableRows[0].appendChild(helpTextCell);
    tableRows[1].appendChild(this.createEmptyCell());
   }
   if(captionPosition === ASPx.Position.Right && this.isVertical(errorCellPosition)) {
    captionCell.parentNode.insertBefore(helpTextCell, captionCell);
    var emptyCellParentRow = errorCellPosition === ASPx.Position.Top ? tableRows[0] : tableRows[1];
    var helpTextCellIndex = this.getCellIndex(helpTextCell.parentNode, helpTextCell);
    emptyCellParentRow.insertBefore(this.createEmptyCell(), this.getCellByIndex(emptyCellParentRow, helpTextCellIndex));
   }
  }
  if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Top && this.isHorizontal(errorCellPosition)) {
   if(errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
   }
   else {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell());
   }
   errorTableBody.insertBefore(helpTextRow, captionCell.parentNode.nextSibling);
  }
  if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Top && this.isHorizontal(errorCellPosition)) {
   if(errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
   }
   else {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell());
   }
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Bottom && this.isHorizontal(errorCellPosition)) {
   if(errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
   }
   else {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell());
   }
   errorTableBody.insertBefore(helpTextRow, captionCell.parentNode);
  }
  if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Left) {
   helpTextRow.appendChild(this.createEmptyCell(true));
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.appendChild(helpTextRow);
  }
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Bottom) {
   helpTextRow.appendChild(helpTextCell);
   helpTextRow.appendChild(this.createEmptyCell());
   errorTableBody.appendChild(helpTextRow);
  }
  if(this.position === ASPx.Position.Bottom) {
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Right || captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(errorCellPosition !== ASPx.Position.Right));
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell(errorCellPosition === ASPx.Position.Right));
    errorTableBody.appendChild(helpTextRow);
   }
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(false));
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
    errorTableBody.appendChild(helpTextRow);
   }
   if(captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Right) {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(this.createEmptyCell(false));
    errorTableBody.appendChild(helpTextRow);
   }   
  }
  if(this.position === ASPx.Position.Top) {
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Right || captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(errorCellPosition !== ASPx.Position.Right));
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell(errorCellPosition === ASPx.Position.Right));
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(false));
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Right) {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(this.createEmptyCell(false));
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   }
  }
 },
 addHelpTextCellToExternalTableWithErrorCell: function (errorCell, helpTextCell, errorTableBody, tableRows) {
  var errorCellPosition = this.editor.errorCellPosition;
  var helpTextRow = document.createElement("TR");
  if(this.position === ASPx.Position.Left && this.isHorizontal(errorCellPosition))
   tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
  if(this.position === ASPx.Position.Right && this.isHorizontal(errorCellPosition))
   tableRows[0].appendChild(helpTextCell);
  if(this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(this.position === ASPx.Position.Bottom && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.appendChild(helpTextRow);
  }
  if(errorCellPosition === ASPx.Position.Left && this.isVertical(this.position)) {
   helpTextRow.appendChild(this.createEmptyCell(true));
   helpTextRow.appendChild(helpTextCell);
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
  if(errorCellPosition === ASPx.Position.Right && this.isVertical(this.position)) {
   helpTextRow.appendChild(helpTextCell);
   helpTextRow.appendChild(this.createEmptyCell(true));
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
  if(this.position === ASPx.Position.Left && this.isVertical(errorCellPosition)) {
   var helpTextParentRowIndex = errorCellPosition === ASPx.Position.Top ? 1 : 0;
   var emptyCellRowIndex = helpTextParentRowIndex === 0 ? 1 : 0;
   tableRows[helpTextParentRowIndex].insertBefore(helpTextCell, tableRows[helpTextParentRowIndex].childNodes[0]);
   tableRows[emptyCellRowIndex].insertBefore(this.createEmptyCell(true), tableRows[emptyCellRowIndex].childNodes[0]);
  }
  if(this.position === ASPx.Position.Right && this.isVertical(errorCellPosition)) {
   var helpTextParentRowIndex = errorCellPosition === ASPx.Position.Top ? 1 : 0;
   var emptyCellRowIndex = helpTextParentRowIndex === 0 ? 1 : 0;
   tableRows[helpTextParentRowIndex].appendChild(helpTextCell);
   tableRows[emptyCellRowIndex].appendChild(this.createEmptyCell(true));
  }
 },
 addHelpTextCellToExternalTableWithCaption: function (captionCell, helpTextCell, errorTableBody, tableRows) {
  var captionPosition = this.editor.captionPosition;
  var helpTextRow = document.createElement("TR");
  if(captionPosition === ASPx.Position.Left && this.isVertical(this.position)) {
   helpTextRow.appendChild(this.createEmptyCell());
   helpTextRow.appendChild(helpTextCell);
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
  if(this.position === ASPx.Position.Left && this.isVertical(captionPosition)) {
   var helpTextParentRowIndex = captionPosition === ASPx.Position.Top ? 1 : 0;
   var emptyCellParentRowIndex = helpTextParentRowIndex === 0 ? 1 : 0;
   tableRows[helpTextParentRowIndex].insertBefore(helpTextCell, tableRows[helpTextParentRowIndex].childNodes[0]);
   tableRows[emptyCellParentRowIndex].insertBefore(this.createEmptyCell(), tableRows[emptyCellParentRowIndex].childNodes[0]);
  }
  if(this.position === ASPx.Position.Right && this.isVertical(captionPosition)) {
   var helpTextParentRowIndex = captionPosition === ASPx.Position.Top ? 1 : 0;
   var emptyCellParentRowIndex = helpTextParentRowIndex === 0 ? 1 : 0;
   tableRows[helpTextParentRowIndex].appendChild(helpTextCell);
   tableRows[emptyCellParentRowIndex].appendChild(this.createEmptyCell());
  }
  if(captionPosition === ASPx.Position.Right && this.isVertical(this.position)) {
   helpTextRow.appendChild(helpTextCell);
   helpTextRow.appendChild(this.createEmptyCell());
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
  if(this.isVertical(captionPosition) && this.isVertical(this.position)) {
   helpTextRow.appendChild(helpTextCell);
   if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, captionCell.parentNode.nextSibling);
   if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Bottom)
    errorTableBody.appendChild(helpTextRow);
   if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Bottom)
    errorTableBody.insertBefore(helpTextRow, captionCell.parentNode);
  }
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Left)
   captionCell.parentNode.insertBefore(helpTextCell, captionCell.nextSibling);
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Right)
   captionCell.parentNode.insertBefore(helpTextCell, captionCell);
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Right)
   tableRows[0].appendChild(helpTextCell);
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Left)
   tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
 },
 addHelpTextCellToExternalTableWithEditorOnly: function (helpTextCell, errorTableBody, tableRows) {
  if(this.isHorizontal(this.position)) {
   if(this.position === ASPx.Position.Left)
    tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
   else
    tableRows[0].appendChild(helpTextCell);
  }
  else {
   var helpTextRow = document.createElement("TR");
   helpTextRow.appendChild(helpTextCell);
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
 },
 addHelpTextCellToExternalTable: function (errorTable, helpTextCell) {
  var errorTableBody = ASPx.GetNodeByTagName(errorTable, "TBODY", 0);
  var tableRows = this.getRows(errorTableBody);
  var captionCell = this.editor.GetCaptionCell();
  var errorCell = this.editor.GetErrorCell();
  if(captionCell) {
   if(errorCell)
    this.addHelpTextCellToExternalTableWithTwoCells(captionCell, errorCell, helpTextCell, errorTableBody, tableRows);
   else
    this.addHelpTextCellToExternalTableWithCaption(captionCell, helpTextCell, errorTableBody, tableRows);
  }
  else if(errorCell)
   this.addHelpTextCellToExternalTableWithErrorCell(errorCell, helpTextCell, errorTableBody, tableRows);
  else
   this.addHelpTextCellToExternalTableWithEditorOnly(helpTextCell, errorTableBody, tableRows);
 },
 createExternalTable: function () {
  var externalTable = document.createElement("TABLE");
  externalTable.id = this.editor.name + ASPx.EditElementSuffix.ExternalTable;
  externalTable.cellPadding = 0;
  externalTable.cellSpacing = 0;
  this.applyExternalTableStyle(externalTable);
  var editorWidth = this.editorMainElement.style.width;
  if(ASPx.IsPercentageSize(editorWidth)) {
   externalTable.style.width = editorWidth;
   this.editorMainElement.style.width = "100%";
   this.editor.width = "100%";
  }
  var externalTableBody = document.createElement("TBODY");
  var externalTableRow = document.createElement("TR");
  var externalTableCell = document.createElement("TD");
  externalTable.appendChild(externalTableBody);
  externalTableBody.appendChild(externalTableRow);
  externalTableRow.appendChild(externalTableCell);
  this.editorMainElement.parentNode.appendChild(externalTable);
  ASPx.ChangeElementContainer(this.editorMainElement, externalTableCell, true);
  return externalTable;
 },
 applyExternalTableStyle: function (externalTable) {
  var externalTableStyle = this.editor.externalTableStyle;
  if(externalTableStyle.length > 0) {
   this.applyStyleToElement(externalTable, externalTableStyle);
  }
 },
 applyStyleToElement: function(element, style) {
  element.className = style[0];
  if(style[1]) {
   var styleSheet = ASPx.GetCurrentStyleSheet();
   element.className += " " + ASPx.CreateImportantStyleRule(styleSheet, style[1]);
  }
 },
 createInlineHelpTextElement: function () {
  var helpTextElement = document.createElement("TD");
  var externalTable = this.editor.GetExternalTable();
  if(!externalTable)
   externalTable = this.createExternalTable();
  this.addHelpTextCellToExternalTable(externalTable, helpTextElement);
  return helpTextElement;
 },
 createPopupHelpTextElement: function () {
  var helpTextElement = document.createElement("DIV");
  document.body.appendChild(helpTextElement);
  ASPx.AnimationHelper.setOpacity(helpTextElement, 0);
  return helpTextElement;
 },
 createHelpTextElement: function () {
  return this.displayMode === ASPxClientTextEditHelpTextDisplayMode.Popup ?
   this.createPopupHelpTextElement() : this.createInlineHelpTextElement();
 },
 prepareHelpTextElement: function (helpTextStyle, helpText) {
  this.helpTextElement.id = this.getHelpTextElementId();
  this.applyStyleToElement(this.helpTextElement, helpTextStyle);
  ASPx.SetInnerHtml(this.helpTextElement, "<SPAN>" + helpText + "</SPAN>");
  if(this.displayMode === ASPxClientTextEditHelpTextDisplayMode.Popup)
   this.updatePopupHelpTextPosition();
  else {
   var isVerticalOrientation = this.position === ASPx.Position.Top || this.position === ASPx.Position.Bottom;
   var orientationClassName = isVerticalOrientation ? ASPxClientTextEditHelpTextConsts.VERTICAL_ORIENTATION_CLASS_NAME :
    ASPxClientTextEditHelpTextConsts.HORIZONTAL_ORIENTATION_CLASS_NAME;
   this.helpTextElement.className += " " + orientationClassName;
   this.setInlineHelpTextElementAlign();
   ASPx.SetElementDisplay(this.helpTextElement, this.editor.clientVisible);
  }
 },
 getHelpTextElementId: function() {
  return this.editor.name + ASPx.TEHelpTextElementSuffix;
 },
 setInlineHelpTextElementAlign: function() {
  var hAlignValue = "", vAlignValue = "";
  switch(this.hAlign) {
   case ASPxClientTextEditHelpTextHAlign.Left: hAlignValue = "left"; break;
   case ASPxClientTextEditHelpTextHAlign.Right: hAlignValue = "right"; break;
   case ASPxClientTextEditHelpTextHAlign.Center: hAlignValue = "center"; break;
  }
  switch(this.vAlign) {
   case ASPxClientTextEditHelpTextVAlign.Top: vAlignValue = "top"; break;
   case ASPxClientTextEditHelpTextVAlign.Bottom: vAlignValue = "bottom"; break;
   case ASPxClientTextEditHelpTextVAlign.Middle: vAlignValue = "middle"; break;
  }
  this.helpTextElement.style.textAlign = hAlignValue;
  this.helpTextElement.style.verticalAlign = vAlignValue;
 },
 getHelpTextMargins: function() {
  if(this.margins)
   return this.margins;
  var result = this.defaultMargins;
  if(this.position === ASPx.Position.Top || this.position === ASPx.Position.Bottom)
   result.Left = result.Right = 0;
  else
   result.Top = result.Bottom = 0;
  return result;
 },
 updatePopupHelpTextPosition: function (editorMainElement) {
  var editorWidth = this.editorMainElement.offsetWidth;
  var editorHeight = this.editorMainElement.offsetHeight;
  var helpTextWidth = this.helpTextElement.offsetWidth;
  var helpTextHeight = this.helpTextElement.offsetHeight;
  var editorX = ASPx.GetAbsoluteX(this.editorMainElement);
  var editorY = ASPx.GetAbsoluteY(this.editorMainElement);
  var helpTextX = 0, helpTextY = 0;
  var margins = this.getHelpTextMargins();
  if(this.position === ASPx.Position.Top || this.position === ASPx.Position.Bottom) {
   if(this.position === ASPx.Position.Top)
    helpTextY = editorY - margins.Bottom - helpTextHeight;
   else if(this.position === ASPx.Position.Bottom)
    helpTextY = editorY + editorHeight + margins.Top;
   if(this.hAlign === ASPxClientTextEditHelpTextHAlign.Left)
    helpTextX = editorX + margins.Left;
   else if(this.hAlign === ASPxClientTextEditHelpTextHAlign.Right)
    helpTextX = editorX + editorWidth - helpTextWidth - margins.Right;
   else if(this.hAlign === ASPxClientTextEditHelpTextHAlign.Center) {
    var editorCenterX = editorX + editorWidth / 2;
    var helpTextWidthWithMargins = helpTextWidth + margins.Left + margins.Right;
    helpTextX = editorCenterX - helpTextWidthWithMargins / 2 + margins.Left;
   }
  } else {
   if(this.position === ASPx.Position.Left)
    helpTextX = editorX - margins.Right - helpTextWidth;
   else if(this.position === ASPx.Position.Right)
    helpTextX = editorX + editorWidth + margins.Left;
   if(this.vAlign === ASPxClientTextEditHelpTextVAlign.Top)
    helpTextY = editorY + margins.Top;
   else if(this.vAlign === ASPxClientTextEditHelpTextVAlign.Bottom)
    helpTextY = editorY + editorHeight - helpTextHeight - margins.Bottom;
   else if(this.vAlign === ASPxClientTextEditHelpTextVAlign.Middle) {
    var editorCenterY = editorY + editorHeight / 2;
    var helpTextHeightWithMargins = helpTextHeight + margins.Top + margins.Bottom;
    helpTextY = editorCenterY - helpTextHeightWithMargins / 2 + margins.Top;
   }
  }
  helpTextX = helpTextX < 0 ? 0 : helpTextX;
  helpTextY = helpTextY < 0 ? 0 : helpTextY;
  ASPx.SetAbsoluteX(this.helpTextElement, helpTextX);
  ASPx.SetAbsoluteY(this.helpTextElement, helpTextY);
 },
 setHelpTextZIndex: function (hide) { 
  var newZIndex = 41998 * (hide ? -1 : 1);
  if(this.helpTextElement.style.zIndex != newZIndex)
   this.helpTextElement.style.zIndex = newZIndex;
 },
 hide: function () {
  if(this.displayMode === ASPxClientTextEditHelpTextDisplayMode.Inline) {
   ASPx.SetElementDisplay(this.helpTextElement, false);
  }
  else {
   this.animationEnabled ? ASPx.AnimationHelper.fadeOut(this.helpTextElement) :
    ASPx.AnimationHelper.setOpacity(this.helpTextElement, 0);
   this.setHelpTextZIndex(true);
  }
 },
 show: function () {
  if(this.displayMode === ASPxClientTextEditHelpTextDisplayMode.Inline) {
   ASPx.SetElementDisplay(this.helpTextElement, true);
  }
  else {
   this.updatePopupHelpTextPosition();
   this.animationEnabled ? ASPx.AnimationHelper.fadeIn(this.helpTextElement) :
    ASPx.AnimationHelper.setOpacity(this.helpTextElement, 1);
   this.setHelpTextZIndex(false);
  }
 }
});
var ASPxOutOfRangeWarningManager = ASPx.CreateClass(null, {
 constructor: function (editor, minValue, maxValue, defaultMinValue, defaultMaxValue, outOfRangeWarningElementPosition, valueFormatter) {
  this.editor = editor;
  this.outOfRangeWarningElementPosition = outOfRangeWarningElementPosition;
  this.minValue = minValue;
  this.maxValue = maxValue;
  this.defaultMinValue = defaultMinValue;
  this.defaultMaxValue = defaultMaxValue;
  this.minMaxValueFormatter = valueFormatter;
  this.animationDuration = 150;
  this.CreateOutOfRangeWarningElement();
 },
 SetMinValue: function (minValue) {
  this.minValue = minValue;
  this.UpdateOutOfRangeWarningElementText();
 },
 SetMaxValue: function (maxValue) {
  this.maxValue = maxValue;
  this.UpdateOutOfRangeWarningElementText();
 },
 CreateOutOfRangeWarningElement: function () {
  this.outOfRangeWarningElement = document.createElement("DIV");
  this.outOfRangeWarningElement.id = this.editor.name + "OutOfRWarn";
  ASPx.InsertElementAfter(this.outOfRangeWarningElement, this.editor.GetOutOfRangeWarningElementPrevSibling());
  ASPx.AnimationHelper.setOpacity(this.outOfRangeWarningElement, 0);
  this.outOfRangeWarningElement.className = this.editor.outOfRangeWarningClassName;
  this.UpdateOutOfRangeWarningElementText();
 },
 IsValueInRange: function (value) {
  return (!this.IsMinValueExists() || value >= this.minValue)
   && (!this.IsMaxValueExists() || value <= this.maxValue);
 },
 IsMinValueExists: function() {
  return ASPx.IsExists(this.minValue) && !isNaN(this.minValue) && this.minValue !== this.defaultMinValue;
 },
 IsMaxValueExists: function () {
  return ASPx.IsExists(this.maxValue) && !isNaN(this.maxValue) && this.maxValue !== this.defaultMaxValue;
 },
 GetFormattedTextByValue: function(value) {
  if (this.minMaxValueFormatter)
   return this.minMaxValueFormatter.Format(value);
  return value;
 },
 GetWarningText: function() {
  var textTemplate = arguments[0];
  var valueTexts = [];
  for (var i = 1; i < arguments.length; i++) {
   var valueText = this.GetFormattedTextByValue(arguments[i]);
   valueTexts.push(valueText);
  }
  return ASPx.Formatter.Format(textTemplate, valueTexts);
 },
 UpdateOutOfRangeWarningElementText: function () {
  var text = "";
  if (this.IsMinValueExists() && this.IsMaxValueExists())
   text = this.GetWarningText(this.editor.outOfRangeWarningMessages[0], this.minValue, this.maxValue);
  if (this.IsMinValueExists() && !this.IsMaxValueExists())
   text = this.GetWarningText(this.editor.outOfRangeWarningMessages[1], this.minValue);
  if (!this.IsMinValueExists() && this.IsMaxValueExists())
   text = this.GetWarningText(this.editor.outOfRangeWarningMessages[2], this.maxValue);
  ASPx.SetInnerHtml(this.outOfRangeWarningElement, "<LABEL>" + text + "</LABEL>");
 },
 UpdateOutOfRangeWarningElementVisibility: function (currentValue) {
  var isValidValue = currentValue == null || this.IsValueInRange(currentValue);
  if (!isValidValue && !this.outOfRangeWarningElementShown)
   this.ShowOutOfRangeWarningElement();
  if (isValidValue && this.outOfRangeWarningElementShown)
   this.HideOutOfRangeWarningElement();
 },
 GetOutOfRangeWarningElementCoordinates: function() {
  var editorMainElement = this.editor.GetMainElement();
  var editorWidth = editorMainElement.offsetWidth;
  var editorHeight = editorMainElement.offsetHeight;
  var editorX = ASPx.GetAbsoluteX(editorMainElement);
  var editorY = ASPx.GetAbsoluteY(editorMainElement);
  var outOfRangeWarningElementX = this.outOfRangeWarningElementPosition === ASPx.Position.Right ? editorX + editorWidth : editorX;
  var outOfRangeWarningElementY = this.outOfRangeWarningElementPosition === ASPx.Position.Right ? editorY : editorY + editorHeight;
  outOfRangeWarningElementX = outOfRangeWarningElementX < 0 ? 0 : outOfRangeWarningElementX;
  outOfRangeWarningElementY = outOfRangeWarningElementY < 0 ? 0 : outOfRangeWarningElementY;
  return {
   x: outOfRangeWarningElementX,
   y: outOfRangeWarningElementY
  };
 },
 ShowOutOfRangeWarningElement: function () {
  this.outOfRangeWarningElement.style.display = "inline";
  var outOfRangeWarningElementCoordinates = this.GetOutOfRangeWarningElementCoordinates();
  ASPx.SetAbsoluteX(this.outOfRangeWarningElement, outOfRangeWarningElementCoordinates.x);
  ASPx.SetAbsoluteY(this.outOfRangeWarningElement, outOfRangeWarningElementCoordinates.y);
  ASPx.AnimationHelper.fadeIn(this.outOfRangeWarningElement, null, this.animationDuration);
  this.outOfRangeWarningElementShown = true;
 },
 HideOutOfRangeWarningElement: function () {
  ASPx.AnimationHelper.fadeOut(this.outOfRangeWarningElement, function () {
   ASPx.SetElementDisplay(this.outOfRangeWarningElement, false);
  }.aspxBind(this), this.animationDuration);
  this.outOfRangeWarningElementShown = false;
 }
});
ASPx.MMMouseOut = function(name, evt) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) edit.OnMouseOut(evt);
}
ASPx.MMMouseOver = function(name, evt) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) edit.OnMouseOver(evt);
}
ASPx.MaskHintTimerProc = function() {
 var focusedEditor = ASPx.GetFocusedEditor();
 if(focusedEditor != null && ASPx.IsFunction(focusedEditor.MaskHintTimerProc))
  focusedEditor.MaskHintTimerProc();
}
ASPx.ETextChanged = function(name) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) edit.OnTextChanged(); 
}
ASPx.BEClick = function(name,number){
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) edit.OnButtonClick(number);
}
ASPx.BEClear = function(name, evt) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit && (evt.button === 0 || ASPx.Browser.TouchUI)) {
  var requireFocus = !ASPx.Browser.VirtualKeyboardSupported || ASPx.Browser.MSTouchUI;
  (function performOnClean() {
   if(requireFocus && !edit.IsFocused())
    edit.GetInputElement().focus();
   if(edit.IsFocused() || !requireFocus)
    edit.OnClear();
   else
    window.setTimeout(performOnClean, 100);
  })();
 }
}
ASPx.SetFocusToTextEditWithDelay = function(name) {
 window.setTimeout(function() {
  var edit = ASPx.GetControlCollection().Get(name);
  if(!edit)
   return;
  ASPx.Browser.IE ? edit.SetCaretPosition(0) : edit.SetFocus();
 }, 500);
}
window.ASPxClientTextEdit = ASPxClientTextEdit;
window.ASPxClientTextBoxBase = ASPxClientTextBoxBase;
window.ASPxClientTextBox = ASPxClientTextBox;
window.ASPxClientMemo = ASPxClientMemo;
window.ASPxClientButtonEditBase = ASPxClientButtonEditBase;
window.ASPxClientButtonEdit = ASPxClientButtonEdit;
window.ASPxClientButtonEditClickEventArgs = ASPxClientButtonEditClickEventArgs;
})();

(function() {
var MaskPartBase = ASPx.CreateClass(null, {
 typeCode: 1,
 constructor: function() {
  this.valueInitialized = false;
  this.dateTimeRole = null;
 },
 Grow: function(text) {
  throw "Not supported";
 },
 GetSize: function() {
  throw "Not supported";
 },
 GetValue: function() {
  this.EnsureValueInitialized();
  return this.GetValueCore();
 },
 EnsureValueInitialized: function() {
  if(this.valueInitialized) return;
  this.InitValue();
  this.valueInitialized = true;
 },
 InitValue: function() {
  throw "Not supported";
 }, 
 GetValueCore: function() {
  throw "Not supported";
 },
 Clear: function(startPos, endPos) {
 },
 HandleKey: function(maskInfo, keyInfo, pos) {
  throw "Not supported";
 },
 HandleControlKey: function(maskInfo, keyInfo, pos) {   
  switch(keyInfo.keyCode) {
   case ASPx.Key.Left:
    if(keyInfo.ctrlState)
     maskInfo.MoveToPrevNonLiteral();
    else
     maskInfo.IncCaretPos(-1);
    break;
   case ASPx.Key.Right:
    if(keyInfo.ctrlState)
     maskInfo.MoveToNextNonLiteral();
    else
     maskInfo.IncCaretPos(1);
    break;
  }
 },
 HandleMouseWheel: function(maskInfo, delta, pos) {
 },
 AllowIncreaseSize: function() { 
  return false; 
 },
 SupportsUpDown: function() { 
  return false; 
 },
 IsValid: function() {
  return true;
 },
 GetHintHtml: function() {
  return "";
 }
}); 
var LiteralMaskPart = ASPx.CreateClass(MaskPartBase, {
 typeCode: 2,
 constructor: function() {
  this.constructor.prototype.constructor.call(this);  
  this.literal = "";
 },
 Grow: function(text) {
  this.literal += text;
 }, 
 GetSize: function() {
  return this.literal.length;
 },
 InitValue: function() {
 }, 
 GetValueCore: function() {
  return this.literal;
 },
 HandleKey: function(maskInfo, keyInfo, pos) {
  if(keyInfo.keyCode == 32){
   maskInfo.IncCaretPos();
   return true;
  }
  var ch = String.fromCharCode(keyInfo.keyCode).toLowerCase();
  var index = this.GetValue().toLowerCase().indexOf(ch, pos);
  if(index > -1){
   maskInfo.IncCaretPos(index - pos + 1);
   return true;
  }
  maskInfo.IncCaretPos();
  return false;
 },
 HandleControlKey: function(maskInfo, keyInfo, pos) {
  switch(keyInfo.keyCode) {
   case ASPx.Key.Right:
   case ASPx.Key.Delete:
    maskInfo.IncCaretPos(this.GetSize() - pos);
    break;
   case ASPx.Key.Left:    
   case ASPx.Key.Backspace:
    maskInfo.IncCaretPos(-pos);
    break;
   default:
    MaskPartBase.prototype.HandleControlKey.call(this, maskInfo, keyInfo, pos);
  }
 }
}); 
var EnumMaskPart = ASPx.CreateClass(MaskPartBase, {
 typeCode: 3,
 constructor: function(items, defaultItemIndex) {
  this.constructor.prototype.constructor.call(this);
  this.items = [];
  this.itemIndex = 0;
  this.defaultItemIndex = defaultItemIndex || 0;
  this.PrepareItems(items);
 },
 PrepareItems: function(items){ 
  var hash = {};
  for(var i = 0; i < items.length; i++){
   var item = String(items[i]);
   if(item.length > 0 && !ASPx.IsExists(hash[item])){
    this.items.push(item);
    hash[item] = 1;
   } 
  }
 },
 GetSize: function() {
  return this.GetValue().length;
 },
 InitValue: function() {  
  this.itemIndex = this.defaultItemIndex;
 }, 
 GetValueCore: function() {
  return this.items[this.itemIndex];
 },
 Clear: function(startPos, endPos) {
  this.ClearInternal(startPos);
 },
 ClearInternal: function(pos) {
  var prefix = this.GetValue().substr(0, pos);
  if(prefix.length < 1) {
   this.itemIndex = this.defaultItemIndex;
  } else {
   this.itemIndex = this.FindItemIndexByPrefix(prefix);
  }
 },
 HandleKey: function(maskInfo, keyInfo, pos) {
  var ch = String.fromCharCode(keyInfo.keyCode);
  var prefix = this.GetValue().substr(0, pos) + ch;
  var index = this.FindItemIndexByPrefix(prefix);
  var offset = (index < 0 || this.GetSize() > prefix.length ? this.GetSize() : prefix.length) - pos;
  if(index < 0 && (ch != " " || offset == 0)) {
   maskInfo.SetCaret(maskInfo.caretPos, offset);
   return false;
  }
  if(index > -1)
   this.itemIndex = index;
  maskInfo.SetCaret(1 + maskInfo.caretPos, offset - 1);
  return true;
 },
 HandleControlKey: function(maskInfo, keyInfo, pos) {
  switch(keyInfo.keyCode) {
   case ASPx.Key.Up:
    this.ChangeItemIndex(maskInfo, this.dateTimeRole != null ? 1 : -1, pos);
    break;
   case ASPx.Key.Down:
    this.ChangeItemIndex(maskInfo, this.dateTimeRole != null ? -1 : 1, pos);
    break;    
   case ASPx.Key.Backspace:
    if(keyInfo.ctrlState){
     this.itemIndex = this.defaultItemIndex;
     maskInfo.IncCaretPos(-pos);
    }
    else {
     this.ClearInternal(pos - 1);
     maskInfo.SetCaret(maskInfo.caretPos - 1, 0);
    }
    break;
   case ASPx.Key.Delete:
    if(keyInfo.ctrlState){
     this.itemIndex = this.defaultItemIndex;
     maskInfo.IncCaretPos(this.GetSize() - pos);
    }
    else {
     this.ClearInternal(pos);
     maskInfo.SetCaret(maskInfo.caretPos + 1, 0);
    }
    break;    
   default:
    MaskPartBase.prototype.HandleControlKey.call(this, maskInfo, keyInfo, pos);
  }
 },
 HandleMouseWheel: function(maskInfo, delta, pos) {
  if(this.dateTimeRole == null)
   delta = -delta;
  this.ChangeItemIndex(maskInfo, delta, pos);
 },
 ChangeItemIndex: function(maskInfo, delta, pos) {
  this.itemIndex += delta;
  while(this.itemIndex < 0)
   this.itemIndex += this.items.length;
  while(this.itemIndex > this.items.length - 1)
   this.itemIndex -= this.items.length;
  maskInfo.SetCaret(maskInfo.caretPos - pos, this.GetSize());
 },
 FindItemIndexByPrefix: function(prefix) {  
  prefix = prefix.toLowerCase();
  for(var i = 0; i < this.items.length; i++) {
   var item = this.items[i];
   if(item.toLowerCase().indexOf(prefix) == 0)
    return i;
  }
  return -1;
 },
 SupportsUpDown: function() { 
  return true; 
 },
 GetHintHtml: function() {
  if(this.dateTimeRole != null)
   return "";
  var list = [];
  for(var i = 0; i < this.items.length; i++) {
   var text = this.items[i];
   if(i == this.itemIndex)
    text = "<strong>" + text + "</strong>";
   list.push(text);
  }
  return list.join(", ");
 },
 AllowIncreaseSize: function() {
  var value = this.GetValue();
  if(value) {
   for (var i = 0; i < this.items.length; i++)
    if(this.items[i].length > value.length)
     return true;
  }
  return false;
 }
});
var RangeMaskPart = ASPx.CreateClass(MaskPartBase, {
 typeCode: 4,
 constructor: function(minNumber, maxNumber) {
  this.constructor.prototype.constructor.call(this);  
  if(maxNumber < minNumber)
   maxNumber = minNumber;  
  this.minNumber = minNumber;
  this.maxNumber = maxNumber;
  this.defaultNumber = null;
  this.zeroFill = false;
  this.absNumber = 0;
  this.negative = false;
  this.enableGroups = false;
 },
 GetSize: function() {
  return this.GetValue().length;
 },
 InitValue: function() {
  var number = 0;
  if(this.defaultNumber != null)
   number = this.defaultNumber;
  else {
   if(this.maxNumber < 0)
    number = this.maxNumber;
   else if(this.minNumber < 0)
    number = 0;
   else
    number = this.minNumber;
  }
  this.SetNumber(number);
 }, 
 GetValueCore: function() {
  var value = String(this.absNumber);  
  if(this.zeroFill) {
   var size = Math.max(this.minNumber.toString().length, this.maxNumber.toString().length);
   var incSize = size - value.length;
   for(var i = 0; i < incSize; i++)
    value = "0" + value;
  }
  if(this.enableGroups)
   value = this.AddGroupSeparators(value);
  if(this.negative)
   value = "-" + value;
  return value;
 },
 AddGroupSeparators: function(text) {
  if(text.length < 4)
   return text;
  var temp = [ ];
  var count = Math.ceil(text.length / 3);
  for(var i = 1; i < count; i++)
   temp.unshift(text.substr(text.length - i * 3, 3));
  temp.unshift(text.substr(0, text.length % 3 || 3));
  return temp.join(ASPx.CultureInfo.numGroupSeparator);
 },
 IsGroupSeparatorPos: function(pos) {
  if(!this.enableGroups)
   return false;
  var reversePos = this.GetSize() - pos;
  return reversePos > 0 && reversePos % 4 == 0;
 }, 
 GetNumber: function() {
  var result = this.absNumber;
  if(this.negative)
   result = -result;
  return result;
 },
 SetNumber: function(number) {
  this.negative = (number < 0);
  this.absNumber = Math.abs(number);
 },
 TextToNumber: function(text) {
  if(text == "" || text == "-")
   return 0;  
  if(this.enableGroups)
   text = text.split(ASPx.CultureInfo.numGroupSeparator).join("");
  return Number(text);
 },
 SetText: function(text, checkMinNumber) {
  checkMinNumber = checkMinNumber || Math.abs(this.minNumber) < 2;
  var number = this.TextToNumber(text);
  if(number > this.maxNumber) {
   this.SetNumber(this.maxNumber);
  } else if(checkMinNumber && number < this.minNumber) {
   this.SetNumber(this.minNumber);
  } else {
   this.absNumber = Math.abs(number);
   this.negative = (text.indexOf("-") > -1);
  }  
 },
 Clear: function(startPos, endPos, ignoreZeroFill) {
  var value = this.GetValue();
  var clearLength = endPos - startPos;
  var newText = ASPx.Str.InsertEx(value, this.zeroFill && !ignoreZeroFill ? new Array(clearLength + 1).join('0') : "", startPos, endPos);
  if(clearLength == value.length && this.defaultNumber !== null)
   this.SetNumber(this.defaultNumber);
  else
   this.SetText(newText, true);
 },
 HandleKey: function(maskInfo, keyInfo, pos) { 
  var keyCode = keyInfo.keyCode;    
  var ch = String.fromCharCode(keyCode);
  if((ch == ASPx.CultureInfo.numGroupSeparator && this.IsGroupSeparatorPos(pos)
   || keyCode == 32) && pos < this.GetSize()) {
   maskInfo.IncCaretPos();
   return true;
  }
  var oldNumber = this.GetNumber();
  if(MaskManager.IsSignumCode(keyCode)) {
   if((ch == "-" && this.minNumber < 0)  || (ch == "+" && oldNumber < 0)) {      
    var newNumber = -oldNumber;
    if(this.CheckRange(newNumber)) {
     this.negative = !this.negative;
     maskInfo.SetCaret(maskInfo.caretPos - pos + (this.negative ? 1 : 0), 0);
     return true;
    }
   }
  }
  if(MaskManager.IsDigitCode(keyCode)) {
   if(!this.zeroFill && ch == "0" && oldNumber == 0 && pos > this.GetSize() - 1)
    return false;
   this.TryTypeAtPos(maskInfo, ch, pos, 1);
   return true;
  }
  return false;
 },
 HandleControlKey: function(maskInfo, keyInfo, pos) {
  switch(keyInfo.keyCode) {
   case ASPx.Key.Up:    
    this.ChangeNumber(maskInfo, 1, pos);
    break;
   case ASPx.Key.Down:
    this.ChangeNumber(maskInfo, -1, pos);
    break;
   case ASPx.Key.Delete:
    if(keyInfo.ctrlState) {    
     var newText = this.GetValue().substr(0, pos);
     this.SetText(newText, false);
     maskInfo.IncCaretPos(this.GetSize() - pos);
    } else {        
     if(this.IsGroupSeparatorPos(pos)) {
      maskInfo.IncCaretPos();
     } else {        
      if(this.zeroFill)
       this.TryTypeAtPos(maskInfo, "0", pos, 1);
      else
       this.TryTypeAtPos(maskInfo, "", pos, 1);
    }
    }
    break;
   case ASPx.Key.Backspace:
    if(keyInfo.ctrlState) {    
     var newText = this.GetValue().substr(pos);
     this.SetText(newText, false);
     maskInfo.IncCaretPos(-pos);
    } else {       
     if(this.IsGroupSeparatorPos(pos - 1)) {
      maskInfo.IncCaretPos(-1);
     } else {
      if(this.zeroFill)
       this.TryTypeAtPos(maskInfo, "0", pos, -1);
      else
       this.TryTypeAtPos(maskInfo, "", pos, -1);
     }
    }
    break;
   default:
    MaskPartBase.prototype.HandleControlKey.call(this, maskInfo, keyInfo, pos);
  }
 },
 HandleMouseWheel: function(maskInfo, delta, pos) {
  this.ChangeNumber(maskInfo, delta, pos);
 },
 ChangeNumber: function(maskInfo, delta, pos) {
  var number = this.GetNumber();
  if(number < this.minNumber)
   number = this.minNumber;
  var newNumber = number + delta;
  while(newNumber < this.minNumber)
   newNumber += 1 + this.maxNumber - this.minNumber;
  while(newNumber > this.maxNumber)
   newNumber -= 1 + this.maxNumber - this.minNumber;
  this.SetNumber(newNumber);
  maskInfo.SetCaret(maskInfo.caretPos - pos, this.GetSize()); 
 },
 CheckRange: function(number){
  return (this.minNumber <= number && number <= this.maxNumber);
 },
 TryTypeAtPos: function(maskInfo, str, pos, dir) {
  if(dir > 0 && this.IsGroupSeparatorPos(pos)) {
   pos++;
   maskInfo.IncCaretPos();
  }
  var oldSize = this.GetSize();
  var strPos = pos;
  if(dir < 0) strPos -= 1;
  var newText = ASPx.Str.InsertEx(this.GetValue(), str, strPos, strPos + 1);
  if(this.dateTimeRole && dir > 0 && pos == 0 && /\d/.test(str) && !this.CheckRange(this.TextToNumber(newText))) {
   var number = Number(str);
   if(this.negative)
    number = -number;
   if(this.CheckRange(number) && this.IsMaxMagnitude(number)) {
    this.SetNumber(number);
    maskInfo.IncCaretPos(this.GetSize() - pos);
    return; 
   }    
  }
  var newPos;
  this.SetText(newText, false);
  if(dir > 0 && oldSize == pos) {
   newPos = this.GetSize();
  } else  {      
   var diff = 0;
   if(!this.zeroFill) {
    diff = this.GetSize() - oldSize;
    if(dir < 0) diff += 1;
    if(diff > 0) diff = 0;
   }
   newPos = pos + dir + diff;
  }
  if(newPos < 0) newPos = 0;  
  if(newPos > this.GetSize()) newPos = this.GetSize();
  if(this.IsGroupSeparatorPos(newPos))
   newPos++;
  maskInfo.IncCaretPos(newPos - pos);
 }, 
 IsMaxMagnitude: function(number) {
  if(number < 0)
   return number * 10 < this.minNumber;
  return number * 10 > this.maxNumber;
 },
 AllowIncreaseSize: function() {
  return !this.zeroFill && !this.IsMaxMagnitude(this.GetNumber());
 },
 SupportsUpDown: function() { 
  return true; 
 },
 GetHintHtml: function() {
  if(this.dateTimeRole != null)
   return ""; 
  return this.minNumber + ".." + this.maxNumber;
 }
}); 
var PromptMaskPart = ASPx.CreateClass(MaskPartBase, {
 typeCode: 5,
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
  this.required = false;
  this.size = 0;
  this.text = "";
 },
 Grow: function(text) {
  this.size += text.length;
 }, 
 GetSize: function() {
  return this.size;
 },
 InitValue: function() {  
  var size = this.GetSize();
  for(var i = 0; i < size; i++)
   this.text += " ";
 }, 
 GetValueCore: function() {
  return this.text;
 },
 Clear: function(startPos, endPos){
  this.ClearInternal(startPos, endPos - startPos);
 },
 ClearInternal: function(pos, count){
  for(var  i = 0; i < count; i++)
   this.SetCharInPos(" ", i + pos);         
 },
 HandleKey: function(maskInfo, keyInfo, pos) {
  var keyCode = keyInfo.keyCode;  
  if(maskInfo.IsPromptCode(keyCode))
   keyCode = 32;
  if(keyCode != 32 && !this.IsValidCharCode(keyCode, pos))
   return false;
  this.SetCharInPos(String.fromCharCode(keyCode), pos);
  maskInfo.IncCaretPos();
  return true;
 },
 HandleControlKey: function(maskInfo, keyInfo, pos) {
  switch(keyInfo.keyCode) {
   case ASPx.Key.Delete:
    var count = keyInfo.ctrlState ? this.GetSize() - pos : 1;
    this.ClearInternal(pos, count);
    maskInfo.IncCaretPos(count);
    break; 
   case ASPx.Key.Backspace:
    var count = keyInfo.ctrlState ? pos : 1;
    this.ClearInternal(pos - count, count);
    maskInfo.IncCaretPos(-count);
    break;
   default:
    MaskPartBase.prototype.HandleControlKey.call(this, maskInfo, keyInfo, pos);
  }
 }, 
 SetCharInPos: function(ch, pos) {
  this.text = ASPx.Str.InsertEx(this.GetValue(), ch, pos, pos + 1);
 }, 
 IsValidCharCode: function(code, pos) {
  throw "Not supported";
 },
 IsValid: function() {
  if(!this.required)
   return true;
  return this.GetValue().indexOf(" ") < 0;
 }
});
var NumericMaskPart = ASPx.CreateClass(PromptMaskPart, {
 typeCode: 6,
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
  this.acceptsSignum = false;
 },
 IsValidCharCode: function(code, pos) {
  if(MaskManager.IsSignumCode(code)) {
   if(!this.acceptsSignum) return false;
   var value = this.GetValue();
   for(var i = 0; i < pos; i++){
    var currentCode = value.charCodeAt(i);
    if(MaskManager.IsDigitCode(currentCode) || MaskManager.IsSignumCode(currentCode))
     return false;
   }
   return true;
  }
  return MaskManager.IsDigitCode(code);
 } 
});
var CharMaskPart = ASPx.CreateClass(PromptMaskPart, {
 typeCode: 7,
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
  this.caseConvention = 0;
 },
 SetCharInPos: function(ch, pos) {
  if(this.caseConvention < 0)
   ch = ch.toLowerCase();
  if(this.caseConvention > 0)
   ch = ch.toUpperCase();   
  PromptMaskPart.prototype.SetCharInPos.call(this, ch, pos);
 }, 
 IsValidCharCode: function(code, pos) {
  return code > 31;
 }
});
var AlphaMaskPart = ASPx.CreateClass(CharMaskPart, {
 typeCode: 8,
 IsValidCharCode: function(code, pos) {
  return MaskManager.IsAlphaCode(code);
 }
}); 
var AlphaNumericMaskPart = ASPx.CreateClass(CharMaskPart, {
 typeCode: 9,
 IsValidCharCode: function(code, pos) {
  return MaskManager.IsAlphaCode(code) || MaskManager.IsDigitCode(code);
 } 
}); 
var REGEX = {};
REGEX.ENUM = {
 SYMBOL: {
  REGULAR: "[^|*<>]",
  REGULAR_ESCAPE_MODE: "[^|*<>\\\\'\"]",
  SLASH_ESCAPED: "\\\\."
 },
 SEQUENCE: {
  APOSTROPHE_ESCAPED: "'[^']+'",
  QUOTES_ESCAPED: '"[^"]+"',
 }
};
REGEX.ENUM.TOKEN = "\\*?(" + REGEX.ENUM.SYMBOL.REGULAR + ")*";
REGEX.ENUM.TOKEN_ESCAPE_MODE = "\\*?(" + REGEX.ENUM.SYMBOL.SLASH_ESCAPED + "|"
 + REGEX.ENUM.SEQUENCE.QUOTES_ESCAPED + "|"
 + REGEX.ENUM.SEQUENCE.APOSTROPHE_ESCAPED + "|"
 + REGEX.ENUM.SYMBOL.REGULAR_ESCAPE_MODE + ")*";
REGEX.ENUM.VALUE = "<" + REGEX.ENUM.TOKEN + "(\\|" + REGEX.ENUM.TOKEN + ")+>";
REGEX.ENUM.VALUE_ESCAPE_MODE = "<" + REGEX.ENUM.TOKEN_ESCAPE_MODE + "(\\|" + REGEX.ENUM.TOKEN_ESCAPE_MODE + ")+>";
REGEX.RANGE = "\\<-?\\d+(\\.\\.-?\\d+){1,2}g?\\>";
REGEX.PROMPT = "[LlAaCc09#,.:/$<>~]";
REGEX.DATE_TIME = "(y{1,4}|M{1,4}|d{1,4}|hh?|HH?|mm?|ss?|F{1,6}|f{1,6}|tt?)";
MASK_PART_TYPE = {
 RANGE: 1,
 ENUM: 2,
 ENUM_ESCAPE_MODE: 4,
 DATE_TIME: 8,
};
REGEX.BY_TYPE = {};
REGEX.BY_TYPE[MASK_PART_TYPE.RANGE] = REGEX.RANGE;
REGEX.BY_TYPE[MASK_PART_TYPE.ENUM] = REGEX.ENUM.VALUE;
REGEX.BY_TYPE[MASK_PART_TYPE.ENUM_ESCAPE_MODE] = REGEX.ENUM.VALUE_ESCAPE_MODE;
REGEX.BY_TYPE[MASK_PART_TYPE.DATE_TIME] = REGEX.DATE_TIME;
var MaskParser = {
 Parse: function(mask, dateTimeOnly, allowEscapingInEnums) {
  this.result = [ ];
  this.currentCaseConvention = 0;  
  this.quoteMode = null;
  this.dateTimeOnly = (dateTimeOnly === true);
  this.allowEscapingInEnums = allowEscapingInEnums;
  mask.replace(this.GetMasterRegex(), this.ParseCallback);
  return this.result;
 },
 GetMasterRegex: function() {
  var masterRegexType = 1 * this.dateTimeOnly + 2 * this.allowEscapingInEnums;
  if(!this.__masterRegex)
   this.__masterRegex = [];
  if(!ASPx.IsExists(this.__masterRegex[masterRegexType])) {
   var pushIfNotOnlyDateTime = function(item) { if(!this.dateTimeOnly) list.push(item); };
   var list = ["\\\\\\\\", "\\\\[\"']", "[\"']"];
   pushIfNotOnlyDateTime(REGEX.RANGE);
   var enumRegex = this.allowEscapingInEnums ? REGEX.ENUM.VALUE_ESCAPE_MODE : REGEX.ENUM.VALUE
   pushIfNotOnlyDateTime(enumRegex);
   list.push("\\\\" + REGEX.DATE_TIME);
   pushIfNotOnlyDateTime("\\\\" + REGEX.PROMPT);
   list.push(REGEX.DATE_TIME);
   pushIfNotOnlyDateTime(REGEX.PROMPT);
   list.push(".");
   this.__masterRegex[masterRegexType] = new RegExp("(" + list.join("|") + ")", "g");   
  }
  return this.__masterRegex[masterRegexType];
 },
 ParseCallback: function(text) {  
  MaskParser.ParseCore(text, null);
 },
 ParseCore: function(text, dateTimeRole) {
  var acceptRangesEnums = (dateTimeRole != null || !this.dateTimeOnly);
  if(text == "'" || text == '"')
   this.ParseQuote(text);
  else if(this.quoteMode != null)
   this.ParseLiteral(text);
  else if(acceptRangesEnums && MaskParser.MatchType(text, MASK_PART_TYPE.RANGE))
   this.ParseRange(text, dateTimeRole);
  else if(acceptRangesEnums && MaskParser.MatchType(text, this.allowEscapingInEnums ? MASK_PART_TYPE.ENUM_ESCAPE_MODE : MASK_PART_TYPE.ENUM))
   this.ParseEnum(text, dateTimeRole);
  else if(MaskParser.MatchType(text, MASK_PART_TYPE.DATE_TIME))
   this.ParseDate(text);
  else
   this.ParseSimple(text);
 },
 MatchType: function(text, type) { return MaskParser.GetAnchoredRegex(type).test(text); },
 GetAnchoredRegex: function(type) {
  if(!this.__regex)
   this.__regex = [];
  if(!this.__regex[type]) 
   this.__regex[type] = new RegExp("^" + REGEX.BY_TYPE[type] + "$");
  return this.__regex[type];
 },
 ParseRange: function(text, dateTimeRole) {
  var enableGroups = false;
  text = this.StripBrockets(text);
  if(text.charAt(text.length - 1) == "g") {
   enableGroups = true;
   text = text.substr(0, text.length - 1);
  }
  var data = text.split("..");
  var minNumber, maxNumber = 0;
  var defaultNumber = null;
  if(data.length == 2){
   minNumber = Number(data[0]);
   maxNumber = Number(data[1]);
  }
  else if(data.length == 3){
   minNumber = Number(data[0]);
   maxNumber = Number(data[2]);
   defaultNumber = Number(data[1]);
  }
  var part = new RangeMaskPart(minNumber, maxNumber);
  part.defaultNumber = defaultNumber;
  part.zeroFill = (data[0] == "00") || (data[0].length > 1 && data[0].charAt(0) == "0");
  part.dateTimeRole = dateTimeRole;
  part.enableGroups = enableGroups;
  this.result.push(part);
 },
 ParseEnum: function(text, dateTimeRole) {
  var delimReplaceGuid = "2c15b016-6e77-4f62-830a-28569118a972";
  var delimRegex = new RegExp(delimReplaceGuid, "g");
  var defaultItemIndex;
  text = MaskParser.StripBrockets(text);
  if(this.allowEscapingInEnums) {
   var escapeWithSlash = function(str) { return str.replace(/./g, "\\$&"); };
   var quoteOrApostropheEscapedRegex = new RegExp("(" + REGEX.ENUM.SEQUENCE.APOSTROPHE_ESCAPED + "|" + REGEX.ENUM.SEQUENCE.QUOTES_ESCAPED + ")", "g");
   text = text.replace(quoteOrApostropheEscapedRegex, function(str) { return escapeWithSlash(MaskParser.StripBrockets(str)); })
    .replace(/\\\|/g, delimReplaceGuid);
  }
  var enumTokens = text.split("|");
  enumTokens = enumTokens.map(function(enumToken, index) {
   if(/^\*/.test(enumToken))
    defaultItemIndex = index;
   return enumToken.replace(/^\*/, "");
  });
  if(this.allowEscapingInEnums) {
   enumTokens = enumTokens.map(function(enumToken) {
    return enumToken
     .replace(delimRegex, "|")
     .replace(/\\(.)/g, "$1");
   });
  }
  var part = new EnumMaskPart(enumTokens, defaultItemIndex);
  part.dateTimeRole = dateTimeRole;
  this.result.push(part);
 },
 StripBrockets: function(text) {
  return text.substr(1, text.length - 2);
 },   
 ParseSimple: function(text) {  
  switch(text) {
   case ":":
    this.ParseLiteral(ASPx.CultureInfo.ts);
    break;
   case "/":
    this.ParseLiteral(ASPx.CultureInfo.ds);
    break;
   default:
    if(this.dateTimeOnly) {
     this.ParseLiteral(text);     
    } else {
     switch(text) {
      case "L":
      case "l":
       this.ParseChar(text, AlphaMaskPart, text == "L");
       break;
      case "A":
      case "a":
       this.ParseChar(text, AlphaNumericMaskPart, text == "A");   
       break;
      case "C":
      case "c":
       this.ParseChar(text, CharMaskPart, text == "C");
       break;
      case ">":
        this.currentCaseConvention = 1;
        break;       
      case "<":
        this.currentCaseConvention = -1;
        break;      
      case "~":
        this.currentCaseConvention = 0;
        break;       
      case "0":
      case "9":
      case "#":
       this.ParseNumeric(text);   
       break;
      case ".":
       this.ParseLiteral(ASPx.CultureInfo.numDecimalPoint);
       break;
      case ",":
       this.ParseLiteral(ASPx.CultureInfo.numGroupSeparator);
       break;
      case "$":
       this.ParseLiteral(ASPx.CultureInfo.currency);
       break;
      default:
       this.ParseLiteral(text);
       break;                       
     }
    }    
    break;
  }
 },
 ParseChar: function(text, ctor, required) {
  var part = this.GetCurrentPart();
  if(part == null || part.typeCode != ctor.prototype.typeCode || part.required != required || part.caseConvention != this.currentCaseConvention) {
   part = new ctor();
   part.required = required;
   part.caseConvention = this.currentCaseConvention;
   this.result.push(part);
  }
  part.Grow(text);
 },
 ParseNumeric: function(text) {
  var required = text == "0";
  var acceptsSignum = text == "#";
  var part = this.GetCurrentPart();
  if(part == null || part.typeCode != NumericMaskPart.prototype.typeCode || part.required != required || part.acceptsSignum != acceptsSignum) {
   part = new NumericMaskPart();
   part.required = required;
   part.acceptsSignum = acceptsSignum;
   this.result.push(part);
  }
  part.Grow(text);
 },
 ParseLiteral: function(text) {
  var part = this.GetCurrentPart();
  if(part == null || part.typeCode != LiteralMaskPart.prototype.typeCode) {
   part = new LiteralMaskPart();
   this.result.push(part);
  }
  if(text.length > 0 && text.charAt(0) == "\\")
   text = text.substr(1);
  part.Grow(text);
 },
 GetCurrentPart: function() {
  var len = this.result.length;
  if(len < 1)
   return null;
  return this.result[len - 1];
 },
 ParseDate: function(text) {
  this.ParseCore(this.GetDateSpecifierReplacement(text), this.GetDateTimeRole(text));
 },
 GetDateSpecifierReplacement: function(text) {
  switch(text) {
   case "yyyy":    
    return "<0100..9999>"; 
   case "yyy":    
    return "<100..9999>"; 
   case "yy":    
    return "<00..99>";
   case "y":    
    return "<0..99>";
   case "MMMM":    
    return "<" + ASPx.CultureInfo.genMonthNames.join("|") + ">";
   case "MMM":    
    return "<" + ASPx.CultureInfo.abbrMonthNames.join("|") + ">";
   case "MM":    
    return "<01..12>";
   case "M":    
    return "<1..12>";
   case "dddd":
    return "<" + ASPx.CultureInfo.dayNames.join("|") + ">";
   case "ddd":
    return "<" + ASPx.CultureInfo.abbrDayNames.join("|") + ">";
   case "dd":    
    return "<01..31>";
   case "d":    
    return "<1..31>";
   case "hh":
    return "<01..12..12>";
   case "h":
    return "<1..12..12>";
   case "HH":
    return "<00..23>";
   case "H":
    return "<0..23>";
   case "mm":
    return "<00..59>";
   case "m":
    return "<0..59>";
   case "ss":
    return "<00..59>";
   case "s":
    return "<0..59>";
   case "tt":
   case "t":
    if(ASPx.CultureInfo.am.length < 1)
     return "";
    return "<" + this.GetAmPmArray(text.length < 2).join("|") + ">";
  }
  if(/^f{1,6}$/i.test(text)) {
   if(text.length == 1)
    return "<0..9>";
   if(text.length == 2)
    return "<0..99>";    
   return "<0..999>";
  }
  throw "Not supported";
 },  
 GetDateTimeRole: function(text) {
  var ch = text.charAt(0);
  if(ch == "y" || ch == "M" || ch =="d"
   || ch.toLowerCase() == "h" || ch == "m" || ch == "s" 
   || ch.toLowerCase() == "f" || ch == "t")
   return ch;
  return null;
 },
 GetAmPmArray: function(useFirstChar){
  var result = [ ASPx.CultureInfo.am, ASPx.CultureInfo.pm ];
  if(useFirstChar) {
   for(var i = 0; i < result.length; i++)
    result[i] = result[i].charAt(0);   
  }
  return result;
 },
 ParseQuote: function(text) {  
  if(this.quoteMode == null) {
   this.quoteMode = text;
  } else {
   if(text == this.quoteMode)
    this.quoteMode = null;
   else
    this.ParseLiteral(text);
  }
 }
};
var MaskIncludeLiterals = {
 All: 1,
 None: 2,
 DecimalSymbol: 3 
};
var MaskInfo = ASPx.CreateClass(null, { 
 constructor: function() {   
  this.parts = null;
  this.allowMouseWheel = true;
  this.promptChar = "_";  
  this.includeLiterals = MaskIncludeLiterals.All;  
  this.errorText = "";
  this.caretPos = 0;
  this.selectionLength = 0; 
  this.lastEditedPart = null;
 },
 GetSize: function() { 
  var size = 0;
  for(var i = 0; i < this.parts.length; i++)
   size += this.parts[i].GetSize();
  return size;
 },
 GetText: function() {
  var result = "";
  for(var i = 0; i < this.parts.length; i++) {
   var part = this.parts[i];
   if(MaskManager.IsLiteralPart(part) || MaskManager.IsEnumPart(part))
    result += part.GetValue();
   else
    result += part.GetValue().split(" ").join(this.promptChar);
  }
  return result;
 },
 GetValue: function() {
  var list = [];
  var hasNonEmptyValue = false;
  var canPartReturnNull = false;
  var canPartReturnNullConstValue = true;
  for(var i = this.parts.length - 1; i >= 0; i--) {
   var part = this.parts[i];
   if(part.typeCode < PromptMaskPart.prototype.typeCode && 
    (this.includeLiterals == MaskIncludeLiterals.All || part.typeCode != LiteralMaskPart.prototype.typeCode))
     canPartReturnNullConstValue = false;
   canPartReturnNull = part.typeCode >= PromptMaskPart.prototype.typeCode ? canPartReturnNullConstValue : false;
   var partValue = part.GetValue();
   if(MaskManager.IsLiteralPart(part) && MaskManager.IsIgnorableLiteral(partValue, this.includeLiterals))
     continue;
   if(MaskManager.IsRangePart(part) && this.includeLiterals != MaskIncludeLiterals.All)
    partValue = partValue.split(ASPx.CultureInfo.numGroupSeparator).join("");
   var valueToAdd = canPartReturnNull && !hasNonEmptyValue ? ASPx.Str.TrimEnd(partValue) : partValue;
   list.unshift(valueToAdd);
   hasNonEmptyValue = hasNonEmptyValue || !!ASPx.Str.TrimEnd(valueToAdd);
  }
  return list.join("");
 },
 SetText: function(text) {
  this.Clear();
  this.SetCaret(0, 0);
  this.SetValueCore(text, MaskIncludeLiterals.All);
  this.SetCaret(0, 0);
 },
 SetValue: function(value) {
  this.Clear();
  this.SetCaret(0, 0);
  this.SetValueCore(value, this.includeLiterals);
  this.SetCaret(0, 0);
 },
 SetValueCore: function(value, includeLiterals) {
  if(value == null) return;
  for(var i = 0; i < value.length; i++) {
   var keyInfo = MaskManager.CreateKeyInfo(value.charCodeAt(i), false, false);
   MaskManager.HandleKey(this, keyInfo, false, includeLiterals);
  }
 },
 Clear: function() {
  for(var i = 0; i < this.parts.length; i++) {
   var part = this.parts[i];
   part.Clear(0, part.GetSize());
  }
 },
 ProcessPaste: function(rawText, caretPosAfterPaste) {
  var currentText = this.GetText();
  if (caretPosAfterPaste === rawText.length) { 
   this.Clear();
   this.SetCaret(0, 0);
   this.SetValueCore(rawText, this.includeLiterals);
  } else {
   var leadLength = 0;
   for (var i = 0; i < Math.min(rawText.length, currentText.length); i++) {
    if (rawText.charAt(i) != currentText.charAt(i))
     break;
    leadLength++;
   }
   var pastedText = rawText.substr(leadLength, caretPosAfterPaste - leadLength);
   this.SetCaret(caretPosAfterPaste - pastedText.length, 0);
   var padLength = 0;
   for (var i = pastedText.length + rawText.length; i < currentText.length; i++) {
    pastedText += " ";
    padLength++;
   }
   this.SetValueCore(pastedText, MaskIncludeLiterals.All);
   this.caretPos -= padLength;
  }
 },
 IsValid: function() {
  for(var i = 0; i < this.parts.length; i++) {
   if(!this.parts[i].IsValid())
    return false;
  }
  return true;
 },
 SetCaret: function(caretPos, selectionLength) {
  if(selectionLength < 0) throw "Internal Error";
  this.caretPos = caretPos;
  this.selectionLength = selectionLength;
 },
 IncCaretPos: function(delta) {
  if(!ASPx.IsExists(delta))
   delta = 1;
  this.caretPos += delta;
  this.selectionLength = 0;
 },
 MoveToPrevNonLiteral: function() {
  var partPos = 0;
  var resultPos = 0;
  for(var i = 0; i < this.parts.length; i++) {
   if(partPos >= this.caretPos)
    break;
   var part = this.parts[i];
   var nextPartPos = partPos + part.GetSize();
   if(!MaskManager.IsLiteralPart(part))
    resultPos = nextPartPos < this.caretPos ? nextPartPos : partPos;
   partPos = nextPartPos;
  }
  this.SetCaret(resultPos, 0);
 },  
 MoveToNextNonLiteral: function() {
  var partPos = 0;
  for(var i = 0; i < this.parts.length; i++) {
   var part = this.parts[i];
   var nextPartPos = partPos + part.GetSize();   
   if(nextPartPos > this.caretPos && !MaskManager.IsLiteralPart(part)) {
    if(partPos <= this.caretPos)
     partPos = nextPartPos;
    break;
   }
   partPos = nextPartPos;
  }
  this.SetCaret(partPos, 0);
 }, 
 IsPromptCode: function(code) {
  return (code == 32 || code == this.promptChar.charCodeAt(0));
 },
 BeforeChange: function(part) {
  this.ApplyFixes(part);
  this.lastEditedPart = part;
  part.EnsureValueInitialized();
 },
 AfterChange: function(part) {
 },
 ApplyFixes: function(currentPart) {
  var result1 = this.FixLastRangePart(currentPart);
  var result2 = this.FixLastDatePart(currentPart);
  return result1 || result2;
 },
 FixLastRangePart: function(currentPart) {  
  var part = this.lastEditedPart;
  if(!part || part == currentPart || !MaskManager.IsRangePart(part))
   return false;
  var number = part.GetNumber();
  if(number >= part.minNumber) 
   return false;
  var prevSize = part.GetSize();
  part.SetNumber(part.minNumber);
  this.SetCaret(this.caretPos + part.GetSize() - prevSize, 0);
  return true;
 },
 FixLastDatePart: function(currentPart) {
  var part = this.lastEditedPart;
  if(!part || part == currentPart || part.dateTimeRole == null)
   return false;
  var bag = MaskDateTimeHelper.GetDateBag(this);
  if(!bag.hasDate)
   return false;
  var maxDay = MaskDateTimeHelper.GetMaxDayInMonth(bag.month, bag.year);
  if(bag.day > maxDay) {   
   if(bag.day == 29 && bag.month == 1) {
    bag.year = MaskDateTimeHelper.GetNextLeapYear(bag.year);
   } else {
    if(part.dateTimeRole == "d")
     bag.month--;
    else
     bag.day = maxDay;
   }   
  }
  var prefixSize = this.GetSizeBeforeEditedPart(currentPart);
  MaskDateTimeHelper.SetDate(this, MaskDateTimeHelper.CreateDateFromBag(bag, true));
  this.caretPos += this.GetSizeBeforeEditedPart(currentPart) - prefixSize;
  return true;
 },
 GetSizeBeforeEditedPart: function(currentPart) {
  var pos = 0;
  for(var i = 0; i < this.parts.length; i++) {
   if(this.parts[i] == currentPart)
    break;
   pos += this.parts[i].GetSize();
  }
  return pos;
 } 
});
MaskInfo.Create = function(maskText, dateTimeOnly, allowEscapingInEnums) {
 var info = new MaskInfo();
 info.parts = MaskParser.Parse(maskText, dateTimeOnly, allowEscapingInEnums);
 return info;
}
var MaskManager = {
 OnKeyPress: function(maskInfo, keyInfo) {
  if(maskInfo.selectionLength > 0)
   this.ClearSelection(maskInfo);
  this.HandleKey(maskInfo, keyInfo, true, MaskIncludeLiterals.All);
  this.savedKeyDownKeyInfo = null;
 },
 OnKeyDown: function(maskInfo, keyInfo) {
  if(maskInfo.selectionLength > 0 && (keyInfo.keyCode == ASPx.Key.Backspace || keyInfo.keyCode == ASPx.Key.Delete))
   this.ClearSelection(maskInfo, true);
  else
   this.HandleControlKey(maskInfo, keyInfo);
 },
 OnMouseWheel: function(maskInfo, delta) {
  if(maskInfo.allowMouseWheel)
   this.HandleMouseWheel(maskInfo, delta);
 },
 HandleKey: function(maskInfo, keyInfo, autoSkipLiterals, includeLiterals) { 
  var partStart = 0;
  var caretInfoBeforeSkip = null;  
  for(var i = 0; i < maskInfo.parts.length; i++) {
   var part = maskInfo.parts[i];
   if(this.IsCaretInPart(maskInfo.caretPos, partStart, part)) {    
    if(!this.IsLiteralPart(part) || !this.IsIgnorableLiteral(part.GetValue(), includeLiterals)) {
     var savedCaretPos = maskInfo.caretPos;
     maskInfo.BeforeChange(part);
     partStart += maskInfo.caretPos - savedCaretPos;
     if(this.savedKeyDownKeyInfo && this.savedKeyDownKeyInfo.keyCode == ASPx.Key.Decimal)
      keyInfo.keyCode = ASPx.CultureInfo.numDecimalPoint.charCodeAt(0);
     if(part.HandleKey(maskInfo, keyInfo, maskInfo.caretPos - partStart)) {        
      if(autoSkipLiterals)
       this.TrySkipLiteralOnPartEdge(maskInfo, partStart, i);
      maskInfo.AfterChange(part);
      return;
     }
     if(caretInfoBeforeSkip == null)
      caretInfoBeforeSkip = [ maskInfo.caretPos, maskInfo.selectionLength ];
    }         
    maskInfo.SetCaret(partStart + part.GetSize(), 0);
   }
   partStart += part.GetSize();
  }
  if(caretInfoBeforeSkip != null)
   maskInfo.SetCaret(caretInfoBeforeSkip[0], caretInfoBeforeSkip[1]);
 },
 HandleControlKey: function(maskInfo, keyInfo) {
  maskInfo.selectionLength = 0;
  var partStart = 0;  
  for(var i = 0; i < maskInfo.parts.length; i++) {
   var part = maskInfo.parts[i];
   if(this.IsCaretInPartOnControlKey(maskInfo.caretPos, partStart, part, keyInfo.keyCode)) {
    var savedCaretPos = maskInfo.caretPos;
    maskInfo.BeforeChange(part);
    partStart += maskInfo.caretPos - savedCaretPos;
    part.HandleControlKey(maskInfo, keyInfo, maskInfo.caretPos - partStart);
    if(keyInfo.keyCode == ASPx.Key.Delete)
     this.TrySkipLiteralOnPartEdge(maskInfo, partStart, i);
    maskInfo.AfterChange(part);
    break;
   }
   partStart += part.GetSize();
  }
 },
 HandleMouseWheel: function(maskInfo, delta) {
  var partStart = 0;  
  for(var i = 0; i < maskInfo.parts.length; i++) {
   var part = maskInfo.parts[i];
   if(this.IsCaretInPartOnMouseWheel(maskInfo.caretPos, partStart, part)) {
    var savedCaretPos = maskInfo.caretPos;
    maskInfo.BeforeChange(part);
    partStart += maskInfo.caretPos - savedCaretPos;
    part.HandleMouseWheel(maskInfo, delta, maskInfo.caretPos - partStart);
    maskInfo.AfterChange(part);
    break;
   }   
   partStart += part.GetSize();
  }
 },
 TrySkipLiteralOnPartEdge: function(maskInfo, partStartPos, partIndex) {
  var part = maskInfo.parts[partIndex];
  var posInPart = maskInfo.caretPos - partStartPos;
  var amount = 0;
  if(part.AllowIncreaseSize()) return;
  if(partIndex > maskInfo.parts.length - 3 ||  posInPart < part.GetSize()) return;
  var sibling = maskInfo.parts[partIndex + 1];
  if(this.IsLiteralPart(sibling))
   amount = sibling.GetSize();
  maskInfo.IncCaretPos(amount);
  maskInfo.ApplyFixes(sibling);
 },
 ClearSelection: function(maskInfo, ignoreZeroFill){  
  var partStart = 0;
  for(var i = 0; i < maskInfo.parts.length; i++) {
   var part = maskInfo.parts[i];
   var outerLeft = Math.min(partStart, maskInfo.caretPos);
   var outerRight = Math.max(partStart + part.GetSize(), maskInfo.caretPos + maskInfo.selectionLength);
   var size = part.GetSize();
   if(size + maskInfo.selectionLength > outerRight - outerLeft){
    var innerLeft = Math.max(partStart, maskInfo.caretPos);
    var innerRight = Math.min(partStart + size, maskInfo.caretPos + maskInfo.selectionLength);    
    part.Clear(innerLeft - partStart, innerRight - partStart, ignoreZeroFill);
    maskInfo.selectionLength += part.GetSize() - size;    
   }
   partStart += part.GetSize();
  }
  maskInfo.selectionLength = 0;
 },
 IsCaretInPart: function(caretPos, partStartPos, part) {
  if(caretPos < partStartPos)
   return false;
  var nextPartPos = partStartPos + part.GetSize();
  if(caretPos > nextPartPos)
   return false;
  if(caretPos == nextPartPos)
   return part.AllowIncreaseSize();
  return true;
 },
 IsCaretInPartOnControlKey: function(caretPos, partStartPos, part, keyCode) {
  if(caretPos == partStartPos) {
   if(keyCode == ASPx.Key.Backspace || keyCode == ASPx.Key.Left)
    return false;
   return true;
  }
  var nextPartPos = partStartPos + part.GetSize();
  if(partStartPos < caretPos && caretPos < nextPartPos) 
   return true;
  if(caretPos == nextPartPos) {
   if(keyCode == ASPx.Key.Up || keyCode == ASPx.Key.Down)
    return part.SupportsUpDown();
   if(keyCode == ASPx.Key.Backspace || keyCode == ASPx.Key.Left)
    return true;
   return false;   
  }
  return false;
 },
 IsCaretInPartOnMouseWheel: function(caretPos, partStartPos, part) {
  if(!part.SupportsUpDown()) 
   return false;
  return caretPos >= partStartPos && caretPos <= partStartPos + part.GetSize();
 },
 GetHintHtml: function(maskInfo) {
  var pos = 0;
  for(var i = 0; i < maskInfo.parts.length; i++) {
   var part = maskInfo.parts[i];
   if(this.IsCaretInPartOnMouseWheel(maskInfo.caretPos, pos, part))
    return part.GetHintHtml();
   pos += part.GetSize();
  }
  return "";
 }, 
 CreateKeyInfo: function(keyCode, shiftState, ctrlState) {
  return {
   keyCode: keyCode,
   shiftState: shiftState,
   ctrlState: ctrlState
  }; 
 },
 CreateKeyInfoByEvent: function(evt) {
  return this.CreateKeyInfo(ASPx.Evt.GetKeyCode(evt), evt.shiftKey, evt.ctrlKey || ASPx.Browser.MacOSPlatform && evt.metaKey);
 },
 IsLiteralPart: function(part) {
  return (part.typeCode == LiteralMaskPart.prototype.typeCode);
 }, 
 IsEnumPart: function(part) {
  return (part.typeCode == EnumMaskPart.prototype.typeCode);
 },
 IsRangePart: function(part) {
  return (part.typeCode == RangeMaskPart.prototype.typeCode);
 },
 IsAlphaCode: function(code) {  
  return (64 < code && code < 91 || 96 < code && code < 123 || code > 127);
 },
 IsDigitCode: function(code) {  
  return (47 < code && code < 58);
 },
 IsSignumCode: function(code) {  
  return (code == 43 || code == 45);
 },
 CanHandleControlKey: function(keyInfo) {
  if(keyInfo.shiftState)
   return false;
  return keyInfo.keyCode == ASPx.Key.Up || keyInfo.keyCode == ASPx.Key.Down
   || keyInfo.keyCode == ASPx.Key.Left || keyInfo.keyCode == ASPx.Key.Right
   || keyInfo.keyCode == ASPx.Key.Backspace || keyInfo.keyCode == ASPx.Key.Delete;
 }, 
 IsPrintableKeyCode: function(keyInfo) {
  if(keyInfo.ctrlState) 
   return false;
  var code = keyInfo.keyCode;  
  return code == 32
   || (code >= 48 && code <= 57)
   || (code >= 65 && code <= 90)
   || (code >= 96 && code <= 107)
   || (code >= 109 && code <= 111)
   || (code >= 186 && code <= 192)
   || (code >= 219 && code <= 222);  
 },
 IsIgnorableLiteral: function(text, mode) {
  if(mode == MaskIncludeLiterals.None)
   return true;
  if(mode == MaskIncludeLiterals.All)
   return false;
  return text != ASPx.CultureInfo.numDecimalPoint;
 }
};
MaskManager.keyCancelled = false;
MaskManager.keyDownHandled = false;
MaskManager.savedKeyDownKeyInfo = null;
var MaskDateTimeHelper = {
 GetDate: function(maskInfo, etalonDate, ignoreHasDateParts) {
  return this.CreateDateFromBag(this.GetDateBag(maskInfo, etalonDate), !ignoreHasDateParts && this.HasDateParts(maskInfo));
 },
 GetDateBag: function(maskInfo, etalonDate) {
  var bag = {
   year: 100, 
   month: 0, 
   day: 1,
   hours: 0,
   min: 0,
   sec: 0,
   msec: 0,
   pm: false,
   hasAmPm: false,
   hasDate: false
  };
  if(etalonDate) {
   bag.year = etalonDate.getFullYear();
   bag.month = etalonDate.getMonth();
   bag.day = etalonDate.getDate();
   bag.hours = etalonDate.getHours();
   bag.min = etalonDate.getMinutes();
   bag.sec = etalonDate.getSeconds();
   bag.msec = etalonDate.getMilliseconds();
  }
  for(var i = 0; i < maskInfo.parts.length; i++) {
   var part = maskInfo.parts[i];
   switch(part.dateTimeRole) {
    case "y":     
     bag.year = Number(part.GetValue());
     if(bag.year < 100)
      bag.year = ASPx.DateUtils.ExpandTwoDigitYear(bag.year);     
     bag.hasDate = true;
     break;
    case "M":
     bag.month = MaskManager.IsEnumPart(part) ? part.itemIndex : Number(part.GetValue()) - 1;
     bag.hasDate = true;
     break;
    case "d":
     if(!MaskManager.IsEnumPart(part)) {
      bag.day = Number(part.GetValue());
      bag.hasDate = true;
     }
     break;
    case "H":
    case "h":
     bag.hours = Number(part.GetValue());
     break;
    case "m":
     bag.min = Number(part.GetValue());
     break;
    case "s":
     bag.sec = Number(part.GetValue());
     break;
    case "f":
    case "F":
     bag.msec = Number(part.GetValue());
     break;
    case "t":
     bag.hasAmPm = true;
     bag.pm = MaskManager.IsEnumPart(part) && part.itemIndex > 0;
     break;
   }
  }
  if(bag.hasAmPm) {
   if(!bag.pm && bag.hours == 12)
    bag.hours = 0;
   if(bag.pm && bag.hours < 12)
    bag.hours += 12;
  }
  return bag;
 },
 CreateDateFromBag: function(bag, allowNull) {
  if(allowNull) {
   if(bag.year == 100 && bag.month == 0 && bag.day == 1 
    && bag.hours + bag.min + bag.sec + bag.msec == 0)
    return null;
  }
  var date = new Date(bag.year, bag.month, bag.day, bag.hours, bag.min, bag.sec, bag.msec);
  ASPx.DateUtils.FixTimezoneGap(
   new Date(bag.year, bag.month, date.getDate() > 1 ? bag.day - 1 : bag.day + 1, bag.hours, bag.min, bag.sec, bag.msec),
   date
  );
  return date;
 },
 GetMaxDayInMonth: function(month, year) {
  if(month == 1)
   return this.IsLeapYear(year) ? 29 : 28;
  if(month == 3 || month == 5 || month == 8 || month == 10)
   return 30;
  return 31;
 },
 IsLeapYear: function(year) {
  if(year % 4 != 0)
   return false;
  if(year % 100 == 0)  
   return year % 400 == 0;
  return true;
 },
 GetNextLeapYear: function(year) {
  var result = 4 * (1 + Math.floor(year / 4));
  if(!this.IsLeapYear(result))
   result += 4;
  return result;
 }, 
 SetDate: function(maskInfo, date) {
  if(date == null)
   date = new Date(100, 0, 1);
  for(var i = 0; i < maskInfo.parts.length; i++) {
   var part = maskInfo.parts[i];
   part.EnsureValueInitialized();   
   switch(part.dateTimeRole) {
    case "y":
     this.SetYear(part, date);
     break;
    case "M":
     this.SetMonth(part, date);
     break;
    case "d":
     this.SetDay(part, date);
     break;
    case "h":
     this.SetHours(part, date, false);
     break;
    case "H":
     this.SetHours(part, date, true);
     break; 
    case "m":
     this.SetMinutes(part, date);
     break;
    case "s":
     this.SetSeconds(part, date);      
     break;
    case "f":
    case "F":
     this.SetMilliseconds(part, date);
     break;
    case "t":
     this.SetAmPm(part, date);      
     break;      
   }   
  }
 },
 SetYear: function(part, date) {
  if(!MaskManager.IsRangePart(part))
   return;
  var value = date.getFullYear();
  if(part.maxNumber < 100)
   value = value % 100;
  part.SetNumber(value);
 },
 SetMonth: function(part, date) { 
  if(MaskManager.IsRangePart(part))
   part.SetNumber(1 + date.getMonth());
  else if(MaskManager.IsEnumPart(part))
   part.itemIndex = date.getMonth();
 },
 SetDay: function(part, date) {
  if(MaskManager.IsRangePart(part))
   part.SetNumber(date.getDate());
  else if(MaskManager.IsEnumPart(part))
   part.itemIndex = date.getDay();
 },
 SetHours: function(part, date, full) {
  if(!MaskManager.IsRangePart(part))
   return; 
  var value = date.getHours();
  if(!full) {
   value = value % 12;
   if(value == 0)
    value = 12;
  }
  part.SetNumber(value);
 },
 SetMinutes: function(part, date) {
  if(!MaskManager.IsRangePart(part))
   return; 
  part.SetNumber(date.getMinutes());
 },
 SetSeconds: function(part, date) {
  if(!MaskManager.IsRangePart(part))
   return;
  part.SetNumber(date.getSeconds());
 },
 SetMilliseconds: function(part, date) {
  if(!MaskManager.IsRangePart(part))
   return;
  var value = date.getMilliseconds();
  while(value > part.maxNumber)
   value = value / 10;
  part.SetNumber(Math.round(value));
 },
 SetAmPm: function(part, date) {
  if(!MaskManager.IsEnumPart(part))
   return; 
  part.itemIndex = date.getHours() < 12 ? 0 : 1;
 },
 HasDateParts: function(maskInfo) {
  var list = maskInfo.parts;
  for(var i = 0; i < list.length; i++) {
   var role = list[i].dateTimeRole;
   if(role == "d" || role == "M" || role == "y")
    return true;
  }
  return false;
 }
};
ASPx.MaskPartBase = MaskPartBase;
ASPx.LiteralMaskPart = LiteralMaskPart;
ASPx.EnumMaskPart = EnumMaskPart;
ASPx.RangeMaskPart = RangeMaskPart;
ASPx.PromptMaskPart = PromptMaskPart;
ASPx.NumericMaskPart = NumericMaskPart;
ASPx.CharMaskPart = CharMaskPart;
ASPx.AlphaMaskPart = AlphaMaskPart;
ASPx.AlphaNumericMaskPart = AlphaNumericMaskPart;
ASPx.MaskParser = MaskParser;
ASPx.MaskInfo = MaskInfo;
ASPx.MaskManager = MaskManager;
ASPx.MaskDateTimeHelper = MaskDateTimeHelper;
ASPx.MaskIncludeLiterals = MaskIncludeLiterals;
})();
(function() {
var DateFormatter = ASPx.CreateClass(null, {
 constructor: function() {
  this.date = new Date(2000, 0, 1);
  this.mask;
  this.specifiers = {};     
  this.spPositions = [];    
  this.parserKeys = [];
  this.knownSpecifiers = ["d", "M", "y", "H", "h", "m", "s", "f", "F", "g", "t"];
  this.savedYear = -1;
  this.isYearParsed = false;
  this.parsedMonth = -1;
  this.replacers = {
   "d": this.ReplaceDay,
   "M": this.ReplaceMonth,
   "y": this.ReplaceYear,
   "H": this.ReplaceHours23,
   "h": this.ReplaceHours12,
   "m": this.ReplaceMinutes,
   "s": this.ReplaceSeconds,
   "F": this.ReplaceMsTrimmed,
   "f": this.ReplaceMs,
   "g": this.ReplaceEra,
   "t": this.ReplaceAmPm
  };
  this.parsers = {
   "d": this.ParseDay,
   "M": this.ParseMonth,
   "y": this.ParseYear,
   "H": this.ParseHours,
   "h": this.ParseHours,
   "m": this.ParseMinutes,
   "s": this.ParseSeconds,
   "F": this.ParseMs,
   "f": this.ParseMs,
   "g": this.ParseEra,
   "t": this.ParseAmPm
  };
 },
 Format: function(date) {
  this.date = date;
  var sp;
  var pos;
  var replacerKey;
  var result = this.mask;
  for(var i = 0; i < this.spPositions.length; i++) {
   pos = this.spPositions[i];
   sp = this.specifiers[pos];
   replacerKey = sp.substr(0, 1);
   if(this.replacers[replacerKey]) {
    result = result.substr(0, pos) + this.replacers[replacerKey].call(this, sp.length) + result.substr(pos + sp.length);
   }
  }
  return result;
 }, 
 Parse: function(str, rememberParserKeys) {
  var now = new Date();  
  this.savedYear = now.getFullYear();
  this.isYearParsed = false;
  this.parsedMonth = -1;
  this.date = new Date(2000, 0, now.getDate());    
  this.strToParse = str;
  this.catchNumbers(str);  
  var parserKey;
  var sp;
  var pos;
  var parseResult;
  var error = false;
  this.hasAmPm = false;
  for(var i = 0; i < this.spPositions.length; i++) {
   pos = this.spPositions[i];
   sp = this.specifiers[pos];
   parserKey = sp.substr(0, 1);
   if(this.parsers[parserKey]) {
    if(rememberParserKeys)
     this.parserKeys.push(parserKey);
    parseResult = this.parsers[parserKey].call(this, sp.length);
    if(!parseResult) {
     error = true;
     break;
    }
   }
  }
  if(error)
   return false;
  if(this.hasAmPm) {
   if(!this.fixHours())
    return false;
  }
  if(!this.isYearParsed)
   this.date.setYear(this.savedYear);
  if(this.parsedMonth < 0)
   this.parsedMonth = now.getMonth();   
  this.ApplyMonth();
  return this.date;  
 },
 ParseAndMergeWithDate: function(str, sourceDate) {
  this.parserKeys = [];
  var date = this.Parse(str, true);
  if(date && sourceDate) {
   if(!this.HasYear())
    date.setYear(sourceDate.getFullYear());
   if(!this.HasMonth())
    date.setMonth(sourceDate.getMonth());
   if(!this.HasDay())
    date.setDate(sourceDate.getDate());
   if(!this.HasHours())
    date.setHours(sourceDate.getHours());
   if(!this.HasMinutes())
    date.setMinutes(sourceDate.getMinutes());
   if(!this.HasSeconds())
    date.setSeconds(sourceDate.getSeconds());
   if(!this.HasMilliseconds())
    date.setMilliseconds(sourceDate.getMilliseconds());
  }
  this.parserKeys = [];
  return date;
 },
 HasYear: function() { return this.HasParserKey("y"); },
 HasMonth: function() { return this.HasParserKey("M"); },
 HasDay: function() { return this.HasParserKey("d"); },
 HasHours: function() { return this.HasParserKey("h") || this.HasParserKey("H"); },
 HasMinutes: function() { return this.HasParserKey("m"); },
 HasSeconds: function() { return this.HasParserKey("s"); },
 HasMilliseconds: function() { return this.HasParserKey("f") || this.HasParserKey("F"); },
 HasParserKey: function(key) { return ASPx.Data.ArrayIndexOf(this.parserKeys, key) !== -1; },
 ApplyMonth: function() {
  var trial;
  var day = this.date.getDate();
  while(true) {
   trial = new Date();
   trial.setTime(this.date.getTime());   
   trial.setMonth(this.parsedMonth);
   if(trial.getMonth() == this.parsedMonth)
    break;
   --day;
   this.date.setDate(day);
  }
  ASPx.DateUtils.FixTimezoneGap(this.date, trial);
  this.date = trial;
 },
 SetFormatString: function(mask) {
  if(mask.length == 2 && mask.charAt(0) == "%")
   mask = mask.charAt(1);
  this.specifiers = {}; 
  this.spPositions = [];
  this.mask = "";
  var subt = 0;
  var pos = 0;
  var startPos = 0;
  var ch;
  var prevCh = "";
  var skip = false;
  var backslash = false;
  var sp = "";    
  while(true) {
   ch = mask.charAt(pos);
   if(ch == "") {
    if(sp.length > 0)
     this.RegisterSpecifier(startPos, sp);
    break;
   }
   if(ch == "\\" && !backslash) {
    backslash = true;
    subt++;
   } else {
    if(!backslash && (ch == "'" || ch == '"')) {
     skip = !skip;
     subt++;
    } else {     
     if(!skip) {
      if(ch == "/")
       ch = ASPx.CultureInfo.ds;       
      else if(ch == ":")
       ch = ASPx.CultureInfo.ts;
      else if(this.IsKnownSpecifier(ch)) {
       if(prevCh.length == 0)
        prevCh = ch;
       if(ch == prevCh)
        sp += ch;
       else {
        if(sp.length > 0)
         this.RegisterSpecifier(startPos, sp);
        sp = ch;
        startPos = pos - subt;
       }
      }
     }     
     this.mask += ch;
    }      
    backslash = false;
   }            
   prevCh = ch;
   pos++;
  }
  this.spPositions.reverse();
 },
 RegisterSpecifier: function(pos, sp) {
  this.spPositions.push(pos);
  this.specifiers[pos] = sp; 
 },
 ReplaceDay: function(length) {
  if(length < 3) {
   var value = this.date.getDate().toString();
   return length == 2 ? this.padLeft(value, 2) : value;  
  } else if(length == 3) {
   return ASPx.CultureInfo.abbrDayNames[this.date.getDay()];
  } else {
   return ASPx.CultureInfo.dayNames[this.date.getDay()];
  }
 }, 
 ReplaceMonth: function(length) {
  var value = 1 + this.date.getMonth();
  switch(length) {
   case 1:
    return value.toString();
   case 2:
    return this.padLeft(value.toString(), 2);
   case 3:
    return ASPx.CultureInfo.abbrMonthNames[value - 1];
   default:
    for(var i in this.specifiers) {
     var spec = this.specifiers[i];
     if(spec == "d" || spec == "dd")
      return ASPx.CultureInfo.genMonthNames[value - 1];
  }
    return ASPx.CultureInfo.monthNames[value - 1];
  }
 },
 ReplaceYear: function(length) {
  var value = this.date.getFullYear();
  if(length <= 2)
   value = value % 100;
  return this.padLeft(value.toString(), length);
 },
 ReplaceHours23: function(length) {
  var value = this.date.getHours().toString();
  return length > 1 ? this.padLeft(value, 2) : value;
 },
 ReplaceHours12: function(length) {
  var value = this.date.getHours() % 12;
  if(value == 0)
   value = 12;
  value = value.toString();
  return length > 1 ? this.padLeft(value, 2) : value;
 },
 ReplaceMinutes: function(length) {
  var value = this.date.getMinutes().toString();
  return length > 1 ? this.padLeft(value, 2) : value;
 },
 ReplaceSeconds: function(length) {
  var value = this.date.getSeconds().toString();
  return length > 1 ? this.padLeft(value, 2) : value;
 },
 ReplaceMsTrimmed: function(length) {   
  return this.formatMs(length, true);
 },
 ReplaceMs: function(length) { 
  return this.formatMs(length, false);
 },
 ReplaceEra: function(length) {
  return "A.D.";
 },
 ReplaceAmPm: function(length) {
  var value = this.date.getHours() < 12 ? ASPx.CultureInfo.am : ASPx.CultureInfo.pm;
  return length < 2 ? value.charAt(0) : value;
 },
 catchNumbers: function(str) {
  this.parseNumbers = [];  
  var regex = /\d+/g;  
  var match;
  for(;;) {
   match = regex.exec(str);
   if(!match)
    break;
   this.parseNumbers.push(this.parseDecInt(match[0]));
  }  
  var spCount = 0;
  var now = new Date();
  for(var i in this.specifiers) {
   var sp = this.specifiers[i];
   if(sp.constructor != String || !this.IsNumericSpecifier(sp)) continue;
   spCount++;
   if(this.parseNumbers.length < spCount) {    
    var defaultValue = 0;
    if(sp.charAt(0) == "y") defaultValue = now.getFullYear(); 
    this.parseNumbers.push(defaultValue);
   }
  }
  var excess = this.parseNumbers.length - spCount;
  if(excess > 0)
   this.parseNumbers.splice(spCount, excess);  
  this.currentParseNumber = this.parseNumbers.length - 1;
 },
 popParseNumber: function() {
  return this.parseNumbers[this.currentParseNumber--];
 },
 findAbbrMonth: function() {
  return this.findMonthCore(ASPx.CultureInfo.abbrMonthNames);
 },
 findFullMonth: function() {
  return this.findMonthCore(ASPx.CultureInfo.genMonthNames);
 }, 
 findMonthCore: function(monthNames) {
  var inputLower = this.strToParse.toLowerCase();
  for(var i = 0; i < monthNames.length; i++) {
   var monthName = monthNames[i].toLowerCase();
   if(monthName.length > 0 &&  inputLower.indexOf(monthName) > -1) {
    var empty = "";
    for(var j = 0; j < monthName.length; j++) empty += " ";
    this.strToParse = this.strToParse.replace(new RegExp(monthName, "gi"), empty);
    return 1 + parseInt(i);
   }
  }
  return false;
 },
 ParseDay: function(length) {
  if(length < 3) {
   var value = this.popParseNumber();
   if(value < 1 || value > 31)
    return false;
   this.date.setDate(value);
  }
  return true;
 },
 ParseMonth: function(length) {
  var value;
  switch(length){
   case 1:
   case 2:
    value = this.popParseNumber();
    break; 
   case 3:
    value = this.findAbbrMonth();
    break;
   default:
    value = this.findFullMonth();
    break;
  }
  if(value < 1 || value > 12)
   return false;
  this.parsedMonth = value - 1;
  return true;
 }, 
 ParseYear: function(length) {  
  var value = this.popParseNumber();
  if(value > 9999)
   return false;
  if(value < 100)
   value = ASPx.DateUtils.ExpandTwoDigitYear(value);
  this.date.setFullYear(value);
  this.isYearParsed = true;
  return true;
 },
 ParseHours: function(length) {
  var value = this.popParseNumber();
  if(value > 23)
   return false;
  this.date.setHours(value);
  return true;
 },
 ParseMinutes: function(length) {
  var value = this.parseMinSecCore();
  if(value == -1)
   return false;
  this.date.setMinutes(value);
  return true;
 },
 ParseSeconds: function(length) {
  var value = this.parseMinSecCore();
  if(value == -1)
   return false;
  this.date.setSeconds(value);
  return true;
 },
 ParseMs: function(length) {
  if(length > 3)
   length = 3;
  var thr = 1;
  for(var i = 0; i < length; i++)
   thr *= 10;
  thr -= 1;
  var value = this.popParseNumber();
  while(value > thr)
   value /= 10;
  this.date.setMilliseconds(Math.round(value));
  return true;
 },
 ParseEra: function(length) {
  return true;
 },
 ParseAmPm: function(length) {
  this.hasAmPm = ASPx.CultureInfo.am.length > 0 && ASPx.CultureInfo.pm.length > 0;
  return true;
 },
 parseDecInt: function(str) {
  return parseInt(str, 10);
 },
 padLeft: function(str, length) {
  while(str.length < length)
   str = "0" + str;
  return str;
 },
 formatMs: function(length, trim) {
  var value = Math.floor(this.date.getMilliseconds() * Math.pow(10, length - 3));
  value = this.padLeft(value.toString(), length);    
  if(trim) {
   var pos = value.length - 1;
   var req = false;
   while(value.charAt(pos) == "0") {
    req = true;
    pos--;
   }
   if(req)
    value = value.substring(0, pos + 1);   
  }
  return value;
 },
 parseMinSecCore: function() {
  var value = this.popParseNumber();
  return value > 59 ? -1 : value;
 },
 fixHours: function() {
  var state = this.getAmPmState(this.strToParse);
  if(!state) return true;
  var h = this.date.getHours();
  switch(state) {
   case "P":
    if(h > 12) return false;
    if(h < 12)
     this.date.setHours(12 + h);
    break;
   case "A":
    if(h == 12)
     this.date.setHours(0);
  }
  return true;
 },
 getAmPmState: function(str, skipCorrection) {
  var am = ASPx.CultureInfo.am.charAt(0).toLowerCase();
  var pm = ASPx.CultureInfo.pm.charAt(0).toLowerCase();
  var amMatches = new RegExp(am, "gi").exec(str);
  var pmMatches = new RegExp(pm, "gi").exec(str);
  var amCount = amMatches ? amMatches.length : 0;
  var pmCount = pmMatches ? pmMatches.length : 0;
  var hasAm = amCount > 0;
  var hasPm = pmCount > 0;
  if(hasAm ^ hasPm && amCount < 2 && pmCount < 2)
   return hasAm ? "A" : "P";
  if(!skipCorrection) {
   str = str.replace(new RegExp(this.getDayMonthNameReplacePattern(), "gi"), "");
   return this.getAmPmState(str, true);
  }
  return null;
 },
 getDayMonthNameReplacePattern: function() {
  if(!this.dayMonthNameReplacePattern)
   return this.createDayMonthNameReplacePattern();
  return this.dayMonthNameReplacePattern;
 },
 createDayMonthNameReplacePattern: function() {
  var parts = [ ] ;
  parts.push("(?:");
  parts.push(this.createReplacePattern(ASPx.CultureInfo.monthNames));
  parts.push(this.createReplacePattern(ASPx.CultureInfo.genMonthNames));
  parts.push(this.createReplacePattern(ASPx.CultureInfo.abbrMonthNames));
  parts.push(this.createReplacePattern(ASPx.CultureInfo.abbrDayNames));
  parts.push(this.createReplacePattern(ASPx.CultureInfo.dayNames));
  parts.push(")");
  return parts.join("");
 },
 createReplacePattern: function(names) {
  return names && names.length > 0 ? "\\b" + names.join("\\b|\\b") + "\\b" : "";
 },
 IsNumericSpecifier: function(sp) {
  var ch = sp.charAt(0);
  if(ch == "g" || ch == "t" || ((ch == "M" || ch == "d") && sp.length > 2))
   return false;
  return true;
 },
 IsKnownSpecifier: function(sp) {
  if(sp.length > 1)
   sp = sp.charAt(0);
  for(var i = 0; i < this.knownSpecifiers.length; i++) {
   if(this.knownSpecifiers[i] == sp)
    return true;
  }
  return false;
 }
});
DateFormatter.Create = function(format) {
 var instance = new DateFormatter();
 instance.SetFormatString(format);
 return instance;
};
DateFormatter.ExpandPredefinedFormat = function(format) {
 switch(format) {
  case "d":
   return ASPx.CultureInfo.shortDate;
  case "D":
   return ASPx.CultureInfo.longDate;
  case "t":
   return ASPx.CultureInfo.shortTime;
  case "T":
   return ASPx.CultureInfo.longTime;
  case "g":
   return ASPx.CultureInfo.shortDate + " " + ASPx.CultureInfo.shortTime;   
  case "f":
   return ASPx.CultureInfo.longDate + " " + ASPx.CultureInfo.shortTime;
  case "G":
   return ASPx.CultureInfo.shortDate + " " + ASPx.CultureInfo.longTime;
  case "F":
  case "U":
   return ASPx.CultureInfo.longDate + " " + ASPx.CultureInfo.longTime;   
  case "M":
  case "m":
   return ASPx.CultureInfo.monthDay;
  case "Y":
  case "y":
   return ASPx.CultureInfo.yearMonth;   
  case "O":
  case "o":
   return "yyyy'-'MM'-'dd'T'HH':'mm':'ss.fffffff";
  case "R":
  case "r":
   return "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'";
  case "s":
   return "yyyy'-'MM'-'dd'T'HH':'mm':'ss";
  case "u":
    return "yyyy'-'MM'-'dd HH':'mm':'ss'Z'";
 }
 return format;
};
ASPx.DateFormatter = DateFormatter;
})();
(function() {
ASPx.Formatter = {
 Format: function() {
  if(arguments.length < 1) 
   return "";
  var format = arguments[0];
  if(format == null)
   return "";
  var args;
  if(arguments.length > 1 && arguments[1] != null && arguments[1].constructor == Array) {
   args = arguments[1];
  } else {
   args = [ ];
   for(var i = 1; i < arguments.length; i++)
    args.push(arguments[i]);
  }
  var bag = [ ];
  var pos = 0;
  var savedPos = 0;  
  while(pos < format.length) {
   var ch = format.charAt(pos);
   pos++;
   if(ch == '{') {
    bag.push(format.substr(savedPos, pos - savedPos - 1));    
    if(format.charAt(pos) == "{") {
     savedPos = pos;
     pos++;
     continue;
    }
    var spec = this.ParseSpec(format, pos);
    var pos = spec.pos;
    var arg = args[spec.index];
    var argString;
    if(arg == null) {
     argString = "";
    } else if(typeof arg == "number") {
     argString = ASPx.NumberFormatter.Format(spec.format, arg);
    } else if(arg.constructor == Date) {     
     if(spec.format != this.activeDateFormat) {
      this.activeDateFormat = spec.format;
      if(spec.format == "")
       spec.format = "G";      
      if(spec.format.length == 1)
       spec.format = ASPx.DateFormatter.ExpandPredefinedFormat(spec.format);
      this.GetDateFormatter().SetFormatString(spec.format);
     }
     if(this.activeDateFormat == "U")
      arg = ASPx.DateUtils.ToUtcTime(arg);
     argString = this.GetDateFormatter().Format(arg);
    } else {
     argString = String(arg);     
     if(spec.format != "" && argString.length > 0) {
      var num = Number(argString.replace(",", "."));
      if(!isNaN(num))
       argString = ASPx.NumberFormatter.Format(spec.format, num);
     }
    }
    var padLen = spec.width - argString.length;
    if(padLen > 0) {
     if(spec.left)
      bag.push(argString);
     for(var i = 0; i < padLen; i++)
      bag.push(" ");
     if(!spec.left)
      bag.push(argString);
    } else {
     bag.push(argString);
    }
    savedPos = pos;
   }
   else if(ch == "}" && pos < format.length && format.charAt(pos) == "}") {
    bag.push(format.substr(savedPos, pos - savedPos - 1));
    savedPos = pos;
    pos++;
   }
   else if (ch == "}") {
    return "";
   }
  }
  if(savedPos < format.length)
   bag.push(format.substr(savedPos));   
  return bag.join("");
 },
 ParseSpec: function(format, pos) {
  var result = {
   index: -1,   
   left: false,
   width: 0,
   format: "",
   pos: 0
  };
  var savedPos, ch;
  savedPos = pos;
  while(true) {   
   ch = format.charAt(pos);
   if(ch < "0" || ch > "9")
    break;
   pos++;
  }  
  if(pos > savedPos)
   result.index = Number(format.substr(savedPos, pos - savedPos));  
  if(format.charAt(pos) == ",") {
   pos++;
   while(true) {
    ch = format.charAt(pos);
    if(ch != " " && ch != "\t")
     break;
    pos++;
   }
   result.left = format.charAt(pos) == "-";
   if(result.left)
    pos++;   
   savedPos = pos;
   while(true) {
    ch = format.charAt(pos);
    if(ch < "0" || ch > "9")
     break;
    pos++;
   }
   if(pos > savedPos)
    result.width = Number(format.substr(savedPos, pos - savedPos));
  }
  if(format.charAt(pos) == ":") {
   pos++;
   savedPos = pos;
   while(format.charAt(pos) != "}")
    pos++;
   result.format = format.substr(savedPos, pos - savedPos);
  }
  pos++;
  result.pos = pos;
  return result;
 },
 activeDateFormat: null,
 GetDateFormatter: function() {
  if(!this.__dateFormatter)
   this.__dateFormatter = new ASPx.DateFormatter();
  return this.__dateFormatter;
 }
};
ASPx.NumberFormatter = {
 Format: function(format, value) {
  if(isNaN(value))
   return ASPx.CultureInfo.numNan;
  if(!isFinite(value)) {
   return value > 0 
    ? ASPx.CultureInfo.numPosInf 
    : ASPx.CultureInfo.numNegInf;
  }
  this.FillFormatInfo(format);
  if(this.spec == "X")
   return this.FormatHex(value);
  this.FillDigitInfo(value);  
  switch(this.spec) {
   case "C":
    return this.FormatCurrency();
   case "D":
    return this.FormatDecimal();
   case "E":
    return this.FormatExp();
   case "F":
    return this.FormatFixed();
   case "G":   
    return this.FormatGeneral();
   case "N":
    return this.FormatNumber();
   case "P":
    return this.FormatPercent();
   default:
    if(this.custom)
     return this.FormatCustom(format);
    return "?";
  }
 },
 positive: true,
 digits: null,
 pointPos: 0, 
 spec: "",
 prec: -1,  
 upper: true,
 custom: false,
 FormatCurrency: function() {  
  if(this.prec < 0)
   this.prec = ASPx.CultureInfo.currPrec;
  this.Round(this.prec);
  var bag = [ ];
  if(this.positive) {
   switch(ASPx.CultureInfo.currPosPattern) {
    case 0:
     bag.push(ASPx.CultureInfo.currency);
     break;
    case 2:
     bag.push(ASPx.CultureInfo.currency, " ");     
     break;     
   }
  } else {
   switch(ASPx.CultureInfo.currNegPattern) {
    case 0:
     bag.push("(", ASPx.CultureInfo.currency);
     break;
    case 1:
     bag.push("-", ASPx.CultureInfo.currency);
     break;
    case 2:
     bag.push(ASPx.CultureInfo.currency, "-");
     break;
    case 3:
     bag.push(ASPx.CultureInfo.currency);
     break;
    case 4:
     bag.push("(");
     break;
    case 5:
    case 8:
     bag.push("-");
     break;
    case 9:
     bag.push("-", ASPx.CultureInfo.currency, " ");
     break;
    case 11:
     bag.push(ASPx.CultureInfo.currency, " ");
     break;
    case 12:
     bag.push(ASPx.CultureInfo.currency, " -");
     break;
    case 14:
     bag.push("(", ASPx.CultureInfo.currency, " ");
     break;
    case 15:
     bag.push("(");
     break;
   }
  }
  this.AppendGroupedInteger(bag, ASPx.CultureInfo.currGroups, ASPx.CultureInfo.currGroupSeparator);
  if(this.prec > 0) {
   bag.push(ASPx.CultureInfo.currDecimalPoint);
   this.AppendDigits(bag, this.pointPos, this.pointPos + this.prec);
  }
  if(this.positive) {
   switch(ASPx.CultureInfo.currPosPattern) {
    case 1:
     bag.push(ASPx.CultureInfo.currency);
     break;
    case 3:
     bag.push(" ", ASPx.CultureInfo.currency);
     break;     
   }   
  } else {
   switch(ASPx.CultureInfo.currNegPattern) {
    case 0:
    case 14:
     bag.push(")");
     break;
    case 3:
     bag.push("-");
     break;
    case 4:
     bag.push(ASPx.CultureInfo.currency, ")");
     break;
    case 5:
     bag.push(ASPx.CultureInfo.currency);
     break;
    case 6:
     bag.push("-", ASPx.CultureInfo.currency);
     break;
    case 7:
     bag.push(ASPx.CultureInfo.currency, "-");
     break;
    case 8:
     bag.push(" ", ASPx.CultureInfo.currency);
     break;
    case 10:
     bag.push(" ", ASPx.CultureInfo.currency, "-");
     break;
    case 11:
     bag.push("-");
     break;
    case 13:
     bag.push("- ", ASPx.CultureInfo.currency);
     break;
    case 15:
     bag.push(" ", ASPx.CultureInfo.currency, ")");
     break;
   }
  }
  return bag.join("");
 }, 
 FormatDecimal: function() {
  if(this.prec < this.pointPos)
   this.prec = this.pointPos;
  if(this.prec < 1)
   return "0";
  var bag = [ ];
  if(!this.positive)
   bag.push("-");
  this.AppendDigits(bag, this.pointPos - this.prec, this.pointPos);
  return bag.join("");
 },
 FormatExp: function() {  
  if(this.prec < 0)
   this.prec = 6;
  this.Round(1 - this.pointPos + this.prec);
  return this.FormatExpCore(3);
 },
 FormatExpCore: function(minExpDigits) {
  var bag = [ ];
  if(!this.positive)
   bag.push("-");
  this.AppendDigits(bag, 0, 1);
  if(this.prec > 0) {
   bag.push(ASPx.CultureInfo.numDecimalPoint);
   this.AppendDigits(bag, 1, 1 + this.prec);
  }
  bag.push(this.upper ? "E" : "e");
  var order = this.pointPos - 1;  
  if(order >= 0) {
   bag.push("+");
  } else {
   bag.push("-");
   order = -order;
  }
  var orderStr = String(order);
  for(var i = orderStr.length; i < minExpDigits; i++)
   bag.push(0);
  bag.push(orderStr);
  return bag.join("");
 },
 FormatFixed: function() {
  if(this.prec < 0)
   this.prec = ASPx.CultureInfo.numPrec;
  this.Round(this.prec);
  var bag = [ ];
  if(!this.positive)
   bag.push("-");
  if(this.pointPos < 1)
   bag.push(0);
  else
   this.AppendDigits(bag, 0, this.pointPos);
  if(this.prec > 0) {
   bag.push(ASPx.CultureInfo.numDecimalPoint);
   this.AppendDigits(bag, this.pointPos, this.pointPos + this.prec);
  }
  return bag.join(""); 
 },
 FormatGeneral: function() {
  var hasFrac = this.pointPos < this.digits.length;
  var allowExp;
  if(this.prec < 0) {
   allowExp = hasFrac;
   this.prec = hasFrac ? 15 : 10;
  } else {   
   allowExp = true;
   if(this.prec < 1)
    this.prec = hasFrac ? 15 : 10;
   this.Round(this.prec - this.pointPos);
  }
  if(allowExp) {
   if(this.pointPos > this.prec || this.pointPos <= -4) {
    this.prec = this.digits.length - 1;
    return this.FormatExpCore(2);
   }
  }
  this.prec = Math.min(this.prec, Math.max(1, this.digits.length)) - this.pointPos;
  return this.FormatFixed();
 },
 FormatNumber: function() {
  if(this.prec < 0)
   this.prec = ASPx.CultureInfo.numPrec;
  this.Round(this.prec);
  var bag = [ ];
  if(!this.positive) {
   switch(ASPx.CultureInfo.numNegPattern) {
    case 0:
     bag.push("(");
     break;
    case 1:
     bag.push("-");
     break;
    case 2:
     bag.push("- ");
     break;
   }
  }
  this.AppendGroupedInteger(bag, ASPx.CultureInfo.numGroups, ASPx.CultureInfo.numGroupSeparator);
  if(this.prec > 0) {
   bag.push(ASPx.CultureInfo.numDecimalPoint);
   this.AppendDigits(bag, this.pointPos, this.pointPos + this.prec);
  }
  if(!this.positive) {
   switch(ASPx.CultureInfo.numNegPattern) {
    case 0:
     bag.push(")");
     break;
    case 3:
     bag.push("-");
     break;
    case 4:
     bag.push(" -");
     break;
   }
  }
  return bag.join("");
 },
 FormatPercent: function() {
  if(this.prec < 0)
   this.prec = ASPx.CultureInfo.numPrec;
  if(this.digits.length > 0)
   this.pointPos += 2;
  this.Round(this.prec);
  var bag = [ ];
  if(!this.positive)
   bag.push("-");
  if(ASPx.CultureInfo.percentPattern == 2)
   bag.push("%");    
  this.AppendGroupedInteger(bag, ASPx.CultureInfo.numGroups, ASPx.CultureInfo.numGroupSeparator);
  if(this.prec > 0) {
   bag.push(ASPx.CultureInfo.numDecimalPoint);
   this.AppendDigits(bag, this.pointPos, this.pointPos + this.prec);
  }  
  switch(ASPx.CultureInfo.percentPattern) {
   case 0:
    bag.push(" %");
    break;
   case 1:
    bag.push("%");
    break;
  }  
  return bag.join("");
 },
 FormatHex: function(value) {
  var result = value.toString(16);
  if(result.indexOf("(") > -1)
   return result;
  result = this.upper ? result.toUpperCase() : result.toLowerCase();
  if(this.prec <= result.length)
   return result;
  var bag = [ ];
  for(var i = result.length; i < this.prec; i++)
   bag.push(0);
  bag.push(result);
  return bag.join("");
 },
 FormatCustom: function(format) {
  var sectionList = this.GetCustomFormatSections(format);
  var section = this.SelectCustomFormatSection(sectionList);
  if(section == "")
   return this.positive ? "" : "-";
  var info = this.ParseCustomFormatSection(section);
  var lists = this.CreateCustomFormatLists(info);
  if(sectionList.length > 2 && section != sectionList[2]) {
   var zero = lists.i.concat(lists.f).join("").split(0).join("") == "";
   if(zero) {
    section = sectionList[2];
    info = this.ParseCustomFormatSection(section);
    lists = this.CreateCustomFormatLists(info);   
   }   
  }
  return this.FormatCustomCore(section, info, lists);
 },
 GetCustomFormatSections: function(format) {
  var sections = [ ];
  var escaping = false;
  var quote = "";
  var length = 0;
  var prevPos = 0;
  for(var i = 0; i < format.length; i++) {
   var ch = format.charAt(i);
   if(!escaping && quote == "" && ch == ";") {
    sections.push(format.substr(prevPos, length));
    length = 0;
    prevPos = i + 1;
    if(sections.length > 2)
     break;
   } else {
    if(escaping)
     escaping = false;
    else if(ch == quote)
     quote = quote == "" ? ch : "";
    else if(ch == "\\")
     escaping = true;
    else if(ch == "'" || ch == '"')
     quote = ch;
    ++length;
   }
  }
  if(length > 0)
   sections.push(format.substr(prevPos, length));
  if(sections.length < 1)
   sections.push(format);
  return sections;
 },
 SelectCustomFormatSection: function(sections) {
  if(!this.positive && sections.length > 1 && sections[1] != "") {
   this.positive = true;
   return sections[1];
  }
  if(this.digits.length < 1 && sections.length > 2 && sections[2] != "")
   return sections[2];
  return sections[0];
 },
 CreateCustomFormatInfo: function() {
  return {
   pointPos: -1,
   grouping: false,
   exp: false,
   expShowPlus: false,
   percent: false,
   scaling: 0,
   intDigits: 0,
   fracDigits: 0,
   expDigits: 0,
   intSharps: 0,
   fracSharps: 0, 
   expSharps: 0
  };
 },
 ParseCustomFormatSection: function(section) {  
  var quote = "";
  var area = "i"; 
  var canParseIntSharps = true;
  var result = this.CreateCustomFormatInfo();
  var groupSeparators = 0;  
  for(var i = 0; i < section.length; i++) {
   var ch = section.charAt(i);   
   if(ch == quote) {
    quote = "";    
    continue;
   }
   if(quote != "")
    continue;
   if(area == "e" && ch != "0" && ch != "#") {
    area = result.pointPos < 0 ? "i" : "f";
    i--;
    continue;
   }
   switch(ch) {
    case "\\":
     i++;
     continue;
    case "'":
    case '"':
     quote = ch;
     continue;
    case "#":
    case "0":
     if(ch == "#") {
      switch(area) {
       case "i":
        if(canParseIntSharps)
         result.intSharps++;
        break;
       case "f":
        result.fracSharps++;
        break;
       case "e":
        result.expSharps++;
        break;
      }
     } else {
      canParseIntSharps = false;
      switch(area) {
       case "f":
        result.fracSharps = 0;        
        break;
       case "e":
        result.expSharps = 0;
        break;
      }
     }
     switch(area) {
      case "i":
       result.intDigits++;
       if(groupSeparators > 0)
        result.grouping = true;
       groupSeparators = 0;
       break;
      case "f":
       result.fracDigits++;  
       break;
      case "e":
       result.expDigits++;
       break;
     }
     break;
    case "e":
    case "E":
     if(result.exp)
      break;
     result.exp = true;     
     area = "e"; 
     if(i < section.length - 1) {
      var next = section.charAt(1 + i);
      if(next == "+" || next == "-") {
       if(next == "+")
        result.expShowPlus = true;
       i++;
      }
      else if(next != "0" && next != "#") {
       result.exp = false;
       if(result.pointPos < 0)
        area = "i";       
      }
     }
     break;
    case ".":
     area = "f";
     if(result.pointPos < 0)
      result.pointPos = i;
     break;
    case "%":
     result.percent = true;     
     break;
    case ",":
     if(area == "i" && result.intDigits > 0)
      groupSeparators++;
     break;
    default:
     break;
   }
  }
  if(result.expDigits < 1)
   result.exp = false;
  else
   result.intSharps = 0;
  if(result.fracDigits < 1)
   result.pointPos = -1;
  result.scaling = 3 * groupSeparators;  
  return result;
 },
 CreateCustomFormatLists: function(info) {
  var intList = [ ];
  var fracList = [ ];
  var expList = [ ];
  if(this.digits.length > 0) {
   if(info.percent)
    this.pointPos += 2;
   this.pointPos -= info.scaling;
  }
  var expPositive = true;
  if(info.exp && (info.intDigits > 0 || info.fracDigits > 0)) {
   var diff = 0;
   if(this.digits.length > 0) {
    this.Round(info.intDigits + info.fracDigits - this.pointPos);
    diff -= this.pointPos - info.intDigits;
    this.pointPos = info.intDigits;
   }
   expPositive = diff <= 0;   
   expList = String(diff < 0 ? -diff : diff).split("");
  } else {
   this.Round(info.fracDigits);
  }
  if(this.digits.length < 1 || this.pointPos < 1)
   intList = [ 0 ];
  else
   this.AppendDigits(intList, 0, this.pointPos);
  this.AppendDigits(fracList, this.pointPos, this.digits.length);
  if(info.exp) {
   while(intList.length < info.intDigits)
    intList.unshift(0);
   while(expList.length < info.expDigits - info.expSharps)
    expList.unshift(0);
   if(expPositive && info.expShowPlus)
    expList.unshift("+");
   else if(!expPositive)
    expList.unshift("-");
  } else {
   while(intList.length < info.intDigits - info.intSharps)
    intList.unshift(0);    
   if(info.intSharps >= info.intDigits) {
    var zero = true;
    for(var i = 0; i < intList.length; i++) {
     if(intList[i] != 0) {
      zero = false;
      break;
     }
    }
    if(zero)
     intList = [ ];
   }
  }
  while(fracList.length < info.fracDigits - info.fracSharps)
   fracList.push(0);
  return {
   i: intList,
   f: fracList,
   e: expList
  };
 },
 FormatCustomCore: function(section, info, lists) {
  var intLen = 0; 
  var total = 0;
  var groupIndex = 0; 
  var counter = 0;
  var groupSize = 0;
  if(info.grouping && ASPx.CultureInfo.numGroups.length > 0) {
   intLen = lists.i.length;
   for(var i = 0; i < ASPx.CultureInfo.numGroups.length; i++) {
    if(total + ASPx.CultureInfo.numGroups[i] <= intLen) {
     total += ASPx.CultureInfo.numGroups[i];
     groupIndex = i;
    }
   }
   groupSize = ASPx.CultureInfo.numGroups[groupIndex];
   var fraction = intLen > total ? intLen - total : 0;
   if(groupSize == 0) {
    while(groupIndex >= 0 && ASPx.CultureInfo.numGroups[groupIndex] == 0)
     groupIndex--;
    groupSize = fraction > 0 ? fraction : ASPx.CultureInfo.numGroups[groupIndex];
   }
   if(fraction == 0) {
    counter = groupSize;
   } else {
    groupIndex += Math.floor(fraction / groupSize);
    counter = fraction % groupSize;
    if(counter == 0)
     counter = groupSize;
    else
     groupIndex++;
   }
  } else {
   info.grouping = false;
  }
  var bag = [ ];
  var area = "i";
  var intSharps = 0;
  var intListIndex = 0;
  var fracListIndex = 0;
  var savedCh = "";
  for(var i = 0; i < section.length; i++) {
   var ch = section.charAt(i);
   if(ch == savedCh) {
    savedCh = "";
    continue;
   }
   if(savedCh != "") {
    bag.push(ch);
    continue;
   }
   switch(ch) {
    case "\\":
     ++i;
     if(i < section.length)
      bag.push(section.charAt(i));
     continue;
    case "'":
    case '"':     
     savedCh = ch;
     continue;
    case "#":     
    case "0":
     if(area == "i") {
      intSharps++;
      if(ch == "0" || info.intDigits - intSharps < lists.i.length + intListIndex) {
       while(info.intDigits - intSharps + intListIndex < lists.i.length) {
        bag.push(lists.i[intListIndex]);
        intListIndex++;
        if(info.grouping && --intLen > 0 && --counter == 0) {
         bag.push(ASPx.CultureInfo.numGroupSeparator);
         if(--groupIndex < ASPx.CultureInfo.numGroups.length && groupIndex >= 0)
          groupSize = ASPx.CultureInfo.numGroups[groupIndex];
         counter = groupSize;
        }
       }
      }
     } else if(area == "f") {
      if(fracListIndex < lists.f.length) {
       bag.push(lists.f[fracListIndex]);
       fracListIndex++;
      }
     }
     break;
    case "e":
    case "E":
     if(lists.e == null || !info.exp) {
      bag.push(ch);
      break;
     }
     for(var q = i + 1; q < section.length; q++) {
      if(q == i + 1 && (section.charAt(q) == "+" || section.charAt(q) == "-"))
       continue;                   
      if(section.charAt(q) == "0" || section.charAt(q) == "#")
       continue;
      break;
     }
     i = q - 1;
     area = info.pointPos < 0 ? "i" : "f";
     bag.push(ch);
     bag = bag.concat(lists.e);
     lists.e = null;      
     break;
    case ".":
     if(info.pointPos == i && lists.f.length > 0)
      bag.push(ASPx.CultureInfo.numDecimalPoint);
     area = "f";
     break;
    case ",":
     break;
    default:
     bag.push(ch);
     break;
   }
  }
  if(!this.positive)
   bag.unshift("-");
  return bag.join("");
 },
 FillDigitInfo: function(value) {
  this.positive = true;
  if(value < 0) {
   value = -value;
   this.positive = false;   
  }
  this.digits = [ ];
  this.pointPos = 0;    
  if(value == 0 || !isFinite(value) || isNaN(value)) {
   this.pointPos = 1;
   return;
  }
  var list = String(value).split("e");
  var str = list[0];
  if(list.length > 1) {   
   this.pointPos = Number(list[1]);
  }
  var frac = false;
  var decimalCount = 0;
  for(var i = 0; i < str.length; i++) {
   var ch = str.charAt(i);
   if(ch == ".") {
    frac = true;
   } else {
    if(frac)
     decimalCount++;     
    if(ch != "0" || this.digits.length > 0)
     this.digits.push(Number(ch));
   }
  }
  this.pointPos += this.digits.length - decimalCount;
 },
 FillFormatInfo: function(format) {
  this.upper = true;
  this.custom = false;
  this.prec = -1;
  var spec;
  if(format == null || format.length < 1)
   spec = "G";
  else
   spec = format.charAt(0);
  if(spec >= "a" && spec <= "z") {
   spec = spec.toUpperCase();
   this.upper = false;
  }
  if(spec >= "A" && spec <= "Z") {   
   if(format != null && format.length > 1) {
    var prec = Number(format.substr(1));
    if(!isNaN(prec))
     this.prec = prec;
    else
     this.custom = true;
   }
  } else {
   this.custom = true;   
  }  
  this.spec = this.custom ? "0" : spec;
 },
 Round: function(shift) {
  var amount = this.digits.length - this.pointPos - shift;
  if(amount <= 0) 
   return;
  var cutPos = this.pointPos + shift;
  if(cutPos < 0) {
   this.digits = [ ];
   this.pointPos = 0;
   return;
  }
  var digit = this.digits[cutPos];
  if(digit > 4) { 
   for(var i = 0; i < amount; i++) {
    var index = cutPos - 1 - i;
    if(index < 0) {
     this.digits.unshift(0);
     this.pointPos++;
     cutPos++;
     index++;
    }
    digit = this.digits[index];    
    if(digit < 9) {
     this.digits[index] = 1 + digit;
     break;
    } else {
     this.digits[index] = 0;
     amount++;
    }
   }
  }
  for(var i = cutPos - 1; i >= 0; i--) {
   if(this.digits[i] > 0) break;
   cutPos--;
  }
  this.digits.splice(cutPos, this.digits.length - cutPos);
 },
 AppendGroupedInteger: function(list, groups, separator) { 
  if(this.pointPos < 1) {
   list.push(0);
   return;
  }
  var total = 0;
  var groupIndex = 0;
  for(var i = 0; i < groups.length; i++) {
   if(total + groups[i] <= this.pointPos) {
    total += groups[i];
    groupIndex = i;
   }
   else
    break;
  }
  if(groups.length > 0 && total > 0) {
   var counter;
   var groupSize = groups[groupIndex];
   var fraction = this.pointPos > total ? this.pointPos - total : 0;
   if(groupSize == 0) {
    while(groupIndex >= 0 && groups[groupIndex] == 0)
     groupIndex--;
    groupSize = fraction > 0 ? fraction : groups[groupIndex];
   }
   if(fraction == 0) {
    counter = groupSize;
   } else {
    groupIndex += Math.floor(fraction / groupSize);
    counter = fraction % groupSize;
    if(counter == 0)
     counter = groupSize;
    else
     groupIndex++;
   }
   var i = 0;
   while(true) {
    if(this.pointPos - i <= counter || counter == 0) {
     this.AppendDigits(list, i, this.pointPos);
     break;
    }
    this.AppendDigits(list, i, i + counter);
    list.push(separator);
    i += counter;    
    groupIndex--;     
    if(groupIndex < groups.length && groupIndex >= 0)
     groupSize = groups[groupIndex];
    counter = groupSize;
   }
  } else {
   this.AppendDigits(list, 0, this.pointPos);   
  }  
 },
 AppendDigits: function(list, start, end) {
  for(var i = start; i < end; i++) {
   if(i < 0 || i >= this.digits.length)
    list.push(0);
   else
    list.push(this.digits[i]);
  }
 }
};
})();
