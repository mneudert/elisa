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

=== TEST 1: Custom query passed as string
--- http_config eval: $::http_config
--- config
    location ~* ^/__elisa__/upstream(.*) {
        internal;

        content_by_lua_block {
            ngx.req.read_body()

            ngx.say(ngx.var.uri)
            ngx.say(ngx.req.get_body_data())
        }
    }

    location /t {
        content_by_lua_block {
            elisa.handle('{"ignore_details":"!!!query!!!"}')
        }
    }
--- request
GET /t?query=foo
--- response_body_like
/__elisa__/upstream/test_data/_search
{"ignore_details":"foo"}

=== TEST 2: Custom query passed as table
--- http_config eval: $::http_config
--- config
    location ~* ^/__elisa__/upstream(.*) {
        internal;

        content_by_lua_block {
            ngx.req.read_body()

            ngx.say(ngx.var.uri)
            ngx.say(ngx.req.get_body_data())
        }
    }

    location /t {
        content_by_lua_block {
            elisa.handle({ ignore_details = '!!!query!!!' })
        }
    }
--- request
GET /t?query=foo
--- response_body_like
/__elisa__/upstream/test_data/_search
{"ignore_details":"foo"}
