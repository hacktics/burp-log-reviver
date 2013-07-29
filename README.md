<article>

<h1>Burp Log Reviver</H1>
<h2>A solution for converting burp logs into sessions, in all burp suite versions</h2>

<p>Burp Log Reviver is an easy-to-use tool, which helps you “revive” a burp log file and transform it to a burp session, even while using the free edition of burp suite.<br>
After reviving the log, you can continue working with your requests and responses, and feel like you never closed burp at all.</p>

<p>Developed by <a href="http://www.hacktics.com" target="_blank">Hacktics ASC</a><br>
<a href="http://www.hacktics.com" target="_blank"><img src="http://diviner.googlecode.com/files/hacktics_logo.jpg" /></a></p>

<p>
<h2>Requirements:</h2>
<ul>
<li> Burp Log Reviver is written in Perl and was tested on Perl <u>v5.12.3</u>.</li>
</ul>
</p>

<p><h2>How Does it Work?</h2>
Burp Log Reviver is responsible for parsing burp’s logs and placing each of the requests and responses into a Hash table.<br>
After parsing and indexing each message, the tool can function in two methods: client and server.<br>
<br>
The Burp Log Reviver client is responsible for sending all requests to burp’s listener port,<br>
while burp is configured to transfer all requests to an upstream proxy, which is configured as the Burp Log Reviver server.<br>
<br>
The Burp Log Reviver server is responsible for responding with its corresponding response and creating a complete loopback solution.<br>
The results of this process allow you to reload your burp sessions and continue working from the place you’ve previously stopped.
</p>

<p>
<h2>Developers</h2>
Burp Log Reviver is developed and maintained by <a href="https://twitter.com/nivselatwit">Niv Sela (@nivselatwit)</a>.
</p>

<p>
<h2>User Guide</h2>

<table border="0">
<tr><td><b><u>Instructions (Requests and Responses):</u></b>
</td></tr>
<tr><td valign="top">
<ol>
<li><I>Record a burp log that includes requests and responses.</I></li>
<li><I>Remove burp history.</I></li>
<li><I>Define burp to listen on port 9999 and set it to "support invisible proxying" mode.</I></li>
<li><I>Define an upstream proxy to localhost:9998.</I></li>
<li><I>Start the server with the following command:<br>./burpLoader.pl c:\BurpLog.txt -L 9998</I></li>
<li><I>Start the client with the following command:<br>./burpLoader.pl c:\BurpLog.txt -C 9999</I></li>
</ol>
</td></tr>

<tr><td><b><u>Instructions (Requests and Real Server’s Reponses)</u></b>
</td></tr>
<tr><td valign="top">
<ol>
<li><I>Remove burp history.</I></li>
<li><I>Define burp to Listen on port 9999 and set it to "support invisible proxying" mode.</I></li>
<li><I>Execute the following command:<br>./burpLoader.pl c:\BurpLog.txt -C 9999</I></li>
</ol>
</td></tr>
</table>
</p>

<p>
<h2>Copyright</h2>
</p>
<p>Burp Log Reviver - A solution for converting burp logs into sessions.</p>

<p>Copyright (C) 2013, Hacktics ASC, Ernst & Young.</p>

<p>This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.</p>

<p>This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.</p>

<p>You should have received a copy of the GNU General Public License along with this program.  If not, see <a href="http://www.gnu.org/licenses/">http://www.gnu.org/licenses</a>.</p>

</article>