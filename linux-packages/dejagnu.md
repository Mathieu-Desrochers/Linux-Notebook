dejagnu
-------
DejaGnu is a framework for testing other programs.

Creating the script
-------------------
Run the following command:

    $ cat > script.exp << "EOF"
    set could_login 0

    spawn ftp ftp.mozilla.org
    expect {
      "Name" {
        send "anonymous\n"
        expect {
          "Password" {
            send "\n"
            expect {
              "ftp>"  { set could_login 1 }
            }
          }
        }
      }
    }

    if { $could_login == 1 } {
      pass "Could login"
    } else {
      fail "Could NOT login"
    }
    EOF

Running the script
------------------
Run the following command:

    $ runtest script.exp
    # of expected passes    1
