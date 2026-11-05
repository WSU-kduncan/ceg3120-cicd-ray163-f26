# Official Apache HTTP Server image
FROM httpd:2.4

# Taken directly from httpd image site.
COPY web-content/ /usr/local/apache2/htdocs/