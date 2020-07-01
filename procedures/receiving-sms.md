Getting a virtual phone number
------------------------------
Open an account with Vonage.  
This service has to be paid for.

    https://www.vonage.com/communications-apis

Buy a number and configure its SMS inbound webhook url.

    http://your-domain:3000/receive-sms-{random-string}

Hosting the webhook
-------------------
Create the following file.

    ~/scripts/receive-sms.py

With the following content.

    import smtplib, ssl

    from email.message import EmailMessage
    from flask import Flask, request, jsonify

    app = Flask(__name__)

    @app.route('/receive-sms-{random-string}', methods=['POST'])
    def receive_sms_{random-string}():
        msg = EmailMessage()

        msg['Subject'] = 'SMS received'
        msg['From'] = 'mail@your-domain'
        msg['To'] = 'mail@your-domain'

        msg.add_header('Content-Type', 'text');
        msg.set_payload(request.data)

        context = ssl._create_unverified_context();

        with smtplib.SMTP('your-domain', 587) as server:
            server.starttls(context=context)
            server.login('mail', 'your-password')
            server.send_message(msg)
            server.quit()

        return ('', 204)

    app.run(host='0.0.0.0', port=3000)

Running as a service
--------------------
Create the following file.

    /usr/local/etc/rc.d/receive_sms

With the following content.

    #!/bin/sh

    # PROVIDE: receive_sms
    # REQUIRE: LOGIN FILESYSTEMS

    . /etc/rc.subr

    name="receive_sms"
    rcvar="receive_sms_enable"
    pidfile="/var/run/${name}.pid"
    start_cmd="${name}_start"
    stop_cmd="${name}_stop"

    receive_sms_start()
    {
      daemon -r -u your-user -P /tmp/receive-sms.pid \
        /usr/local/bin/python3 /home/your-user/scripts/receive-sms.py
    }

    receive_sms_stop()
    {
      if [ -f /tmp/receive-sms.pid ]; then
        kill `cat /tmp/receive-sms.pid`
      fi
    }

    load_rc_config $name
    run_rc_command "$1"

Run the following command:

    sysrc receive_sms_enable="YES"
