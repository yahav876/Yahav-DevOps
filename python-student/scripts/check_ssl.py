import ssl
import socket
from datetime import datetime

domain_names = [
    "unified-exc-na.hismarttv.com",
    "unified-exc-eu.hismarttv.com",
    "unified-exc-sa.hismarttv.com",
    "unified-exc-em.hismarttv.com",
    "unified-exc-jp.hismarttv.com",
    "auth-launcher-jp.hismarttv.com",
    "api-launcher-jp.hismarttv.com",
    "auth-4know-jp.hismarttv.com",
    "api-4know-jp.hismarttv.com",
    "new-download.hismarttv.com",
    "old-download.hismarttv.com",
    "ota-dl-u3.hismarttv.com",
    "ota-dl-u2.hismarttv.com",
    "auth-4know-na.hismarttv.com",
    "api-4know-na.hismarttv.com",
    "auth-na.hismarttv.com",
    "upgrade-na.hismarttv.com",
    "msg-na.hismarttv.com",
    "api-gps-na.hismarttv.com",
    "unified-ter-na.hismarttv.com",
    "api-launcher-na.hismarttv.com",
    "auth-launcher-na.hismarttv.com",
    "auth-webapp-na.hismarttv.com",
    "api-webapp-na.hismarttv.com",
    "api-discovery-na.hismarttv.com",
    "pic-webapp-na.hismarttv.com",
    "pic-launcher-na.hismarttv.com",
    "oauth-na.hismarttv.com",
    "voiceservice-na.hismarttv.com",
    "pic-4know-na.hismarttv.com",
    "sit-oauth-na.hismarttv.com",
    "sit-voiceservice-na.hismarttv.com",
    "auth-voiceservice-na.hismarttv.com",
    "download-emanual-na.hismarttv.com",
    "api-4know-sa.hismarttv.com",
    "api-discovery-sa.hismarttv.com",
    "auth-4know-sa.hismarttv.com",
    "auth-webapp-sa.hismarttv.com",
    "api-webapp-sa.hismarttv.com",
    "auth-launcher-sa.hismarttv.com",
    "api-launcher-sa.hismarttv.com",
    "oauth-sa.hismarttv.com",
    "auth-sa.hismarttv.com",
    "auth-voiceservice-sa.hismarttv.com",
    "upgrade-sa.hismarttv.com",
    "msg-sa.hismarttv.com",
    "api-gps-sa.hismarttv.com",
    "unified-ter-sa.hismarttv.com",
    "voiceservice-sa.hismarttv.com",
    "api-4know-eu.hismarttv.com",
    "api-discovery-eu.hismarttv.com",
    "auth-4know-eu.hismarttv.com",
    "auth-webapp-eu.hismarttv.com",
    "api-webapp-eu.hismarttv.com",
    "auth-launcher-eu.hismarttv.com",
    "api-launcher-eu.hismarttv.com",
    "oauth-eu.hismarttv.com",
    "auth-eu.hismarttv.com",
    "auth-voiceservice-eu.hismarttv.com",
    "upgrade-eu.hismarttv.com",
    "msg-eu.hismarttv.com",
    "api-gps-eu.hismarttv.com",
    "unified-ter-eu.hismarttv.com",
    "voiceservice-eu.hismarttv.com",
    "issue-emanual-na.hismarttv.com",
    "issue-emanual-sa.hismarttv.com",
    "issue-emanual-eu.hismarttv.com",
    "auth-launcher-em.hismarttv.com",
    "auth-4know-em.hismarttv.com",
    "api-4know-em.hismarttv.com",
    "api-discovery-em.hismarttv.com",
    "oauth-em.hismarttv.com",
    "voiceservice-em.hismarttv.com",
    "auth-em.hismarttv.com",
    "auth-voiceservice-em.hismarttv.com",
    "msg-em.hismarttv.com",
    "api-gps-em.hismarttv.com",
    "unified-ter-em.hismarttv.com",
    "upgrade-em.hismarttv.com",
    "auth-webapp-em.hismarttv.com",
    "api-webapp-em.hismarttv.com",
    "api-launcher-em.hismarttv.com",
    "issue-emanual-em.hismarttv.com",
    "ntp-hw.hismarttv.com",
    "auth-jp.hismarttv.com",
    "upgrade-jp.hismarttv.com",
    "picture-us.hismarttv.com",
    "androidtv-appstore-na.hismarttv.com",
    "test-mytv.hismarttv.com"
]

def get_cert_expiration_date(domain):
    context = ssl.create_default_context()
    try:
        with socket.create_connection((domain, 443)) as sock:
            with context.wrap_socket(sock, server_hostname=domain) as ssock:
                cert = ssock.getpeercert()
                expiration_date = cert['notAfter']
                expiration_date = datetime.strptime(expiration_date, "%b %d %H:%M:%S %Y %Z")
                return expiration_date
    except (socket.gaierror, ConnectionError, ssl.SSLError):
        return None

for domain_name in domain_names:
    expiration_date = get_cert_expiration_date(domain_name)
    if expiration_date:
        days_left = (expiration_date - datetime.now()).days
        print(f"Domain: {domain_name}")
        print(f"Certificate Expiration Date: {expiration_date}")
        print(f"Days Left: {days_left} days\n")
    else:
        print(f"Domain: {domain_name}")
        print("Error: Unable to retrieve certificate information\n")
