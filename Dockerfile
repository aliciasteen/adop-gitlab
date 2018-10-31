FROM gitlab/gitlab-ce:11.4.3-ce.0

LABEL maintainer="jonathan.e.jarvis@accenture.com"

# Copy in configuration scripts
COPY resources/scripts/ /home/resources/adop_scripts/
COPY resources/assets/ /assets/

# Execute configuration scripts
RUN chmod +x -R /home/resources/adop_scripts/ \
     &&  chmod +x -R /assets/wrapper

CMD ["/assets/wrapper"]
