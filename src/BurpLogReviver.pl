use IO::Socket;
use IO::Select;
use Class::Struct;

my $index = '-1';
my @Messages;
my $request;
my $response;
my $host;
my $MessagePort;
my $newrequest = 0;
my $newresponse = 0;

struct Message =>
[
    index    => '$',
	host	 =>	'$',
	port	 => '$',
    request  => '$',
    response => '$',
];

if ($#ARGV < 0 || $ARGV[0] eq '' || $ARGV[1] eq '')
{
	print "Usage: ./BurpLogReviver.pl <path> [-L|-C] <1-65535>\n";
	print "-L : Listener - Sending Responses (Default Port : 9998)\n";
	print "-C : Client - Sending Requests (Default Port : 9999) \n";
	print "<path> - Burp log file\n\n";
	print "Credit: Snir Ben Shimol, Shay Chen\n";
	print "Developed by Niv Sela (Ernst & Young)\n";
	exit 1;
}

$path = $ARGV[0];
$mod = $ARGV[1];
$port = $ARGV[2];

if ($mod eq "-L") { 
	if ($port eq '') { $port = "9998"; } 
}
elsif ($mod eq "-C") {
	if ($port eq '') { $port = "9999"; } 
}

if ($path eq '') { $path = 'c:\\log.txt'; }

open FILE, "<", "$path" or die "$path - ".$!; 

while (my $line = <FILE>) 
{
	if (index($line,' '))
	{
		@array = split(' ',$line);
		
		my $ind = 0;
		while ($ind <= $#array) {
		   if ($array[$ind] eq '') {
			  splice(@array, $ind, 1);
		   }
		   else {
			  $ind++;
		   }
		}
		
		if ($#array >= 2)
		{
			if ($array[1] =~ m/(am)|(pm)/ig){ splice(@array,1,1); }
			if ($array[0] =~ m/\d{1,2}\:\d{1,2}\:\d{1,2}/ && $array[1] =~ m/([http|https]\:\/\/[\w|\W]+)(\:\d{1,5})?/ig )
			{
				$numb=$numb+1;
				print "$numb. Extracting Request: ".$line."\n";
				@host = split(':',$array[1]);
				$hostname = "$host[0]:$host[1]";
				$MessagePort = $host[2];
				$new = 1;
			}
		}
	}

	if ($line =~ m/^[a-z].+http\/\d\.\d$/ig)
	{	
		$index++; push(@Messages, Message->new ( index => $index , host => $hostname, port => $MessagePort , request => '' , response => '' ));
		$newrequest = 1; 
		$newresponse = 0;
	}
	
	elsif ($line =~ m/^(http\/\d\.\d\s*\d{1,3})/ig)
	{
		if (exists $Messages[$index] && $Messages[$index]->request ne '') {
			$newresponse = 1; 
		}
		else
		{
			$newresponse = 0;
		}

	}
	elsif ($line =~ /^\=+$/)
	{
		if ($new && $newresponse)
		{
			$new = 0; $newresponse = 0; $response = ''; 
		}
		
		if (exists $Messages[$index] && $newrequest)
		{
			$newrequest = 0; $new = 0;
			$Messages[$index]->request($request);
			$request = '';
			
		}
		if (exists $Messages[$index] && $newresponse)
		{
			$newresponse = 0;
			$Messages[$index]->response($response);
			$response = '';
		}
	}
	
	if ($newrequest)
	{
		$line =~ s/\R//g;
		$request = $request.$line."\r\n";
	}
	
	if ($newresponse)
	{
		$line =~ s/\R//g;
		$response = $response.$line."\r\n";
	}
}

close(FILE);
my $num = 0;

if ($mod eq "-L")
{
	print "Messages: $#Messages\n";
	sendResponses();
}
elsif ($mod eq "-C")
{
	print "Messages: $#Messages\n";
	sendRequests();
}

sub sendRequests()
{
	print "[Sending requests from $path on port : $port]\n";
	for $num (0..$#Messages)
	{
			eval {
				my $ConnectSock = new IO::Socket::INET (
											  PeerAddr => '127.0.0.1',
											  PeerPort => "$port",
											  Proto => 'tcp',
											  Type  => SOCK_STREAM,
											  Timeout => 1
											 );
				
				print "Request Number: ".$Messages[$num]->index." out of $#Messages\n";
				print $ConnectSock $Messages[$num]->request;
				
				my $allData = '';
				my $data = '';
				my $temp = '';
				
				while ($data = <$ConnectSock> && $allData ne $Messages[$num]->response)
				{ 
					$allData = $allData.$data; 
				}
				
				close($ConnectSock);
			};
	}
	$num = 0;
}

sub sendResponses()
{
 eval {
		 my $sock = new IO::Socket::INET (
                                  LocalHost => '127.0.0.1',
                                  LocalPort => "$port",
                                  Proto => 'tcp',
                                  Listen => 1,
                                  Reuse => 20
                                );
								
		 die "Could not create socket: $!\n" unless $sock;

		 print "[Server accepting clients on port : $port]\n";

		 while ($new_sock = $sock->accept())
		 {
			  print "Response Number: ".$Messages[$num]->index." out of $#Messages\n";
			  
			  if ($Messages[$num]->response ne '') {
				print $new_sock $Messages[$num]->response; 
			  }
			  else { 
				print $new_sock "HTTP/1.1 200 OK\r\nServer: None\r\nContent-Type: text\/html; charset=windows-1255\r\nContent-Length: 51\r\n\r\nNo response has been recieved from the server\r\n\r\n\r\n"; 
			  }
			  if ($#Messages == $num) { exit 1; }
			  $num = $num + 1;
		  }
	};
}