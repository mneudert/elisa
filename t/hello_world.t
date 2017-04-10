use Cwd qw(cwd);
use File::Spec;
use Test::Nginx::Socket;

# setup testing environment
$ENV{TEST_NGINX_PORT} ||= 1984;

my $pwd          = cwd();
my $fixture_dir  = File::Spec->catfile($pwd, 't', 'fixtures');
my $fixture_http = File::Spec->catfile($fixture_dir, 'http.conf');

open(my $fh, '<', $fixture_http) or die "cannot open < $fixture_http: $!";
read($fh, our $http_config, -s $fh);
close $fh;

# proceed with testing
repeat_each(2);
plan tests => repeat_each() * blocks() * 2;

no_root_location();
run_tests();

__DATA__

=== TEST 1: Hello World
--- http_config eval: $::http_config
--- config
    location /t {
        content_by_lua_block {
            elisa.handle()
        }
    }
--- request
GET /t
--- response_body
hello world