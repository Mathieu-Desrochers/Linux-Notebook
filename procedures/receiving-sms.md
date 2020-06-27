Getting a virtual phone number
------------------------------
Open an account with Vonage.  
This service has to be paid for.

    https://www.vonage.com/communications-apis

Buy a number and configure its SMS Inbound Webhook URL:

    http://your-domain:3000/webhooks/receive-sms-{random-string}

Hosting the webhook
-------------------
Create the following file.

    ~/receive-sms.py

With the following content.

    import smtplib, ssl

    from email.message import EmailMessage
    from flask import Flask, request, jsonify

    app = Flask(__name__)

    @app.route('/webhooks/receive-sms-{random-string}', methods=['POST'])
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

    app.run(host='your-ip', port=3000)

Run the following command.

    daemon -r -P /tmp/receive-sms.pid /usr/local/bin/python3 receive-sms.py
