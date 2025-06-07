FROM dyalog/dyalog:19.0-unicode

# Set working directory
WORKDIR /app/aplcicd

# Copy package configuration first for better caching
COPY tatin.json ./
COPY aplcicd.dcfg ./

# Install APL dependencies
RUN dyalog -script -e "⎕SE.Tatin.InstallDependencies '/app/aplcicd'"

# Copy APL source code
COPY *.dyalog ./
COPY */*.dyalog ./*/
COPY *.apl ./
COPY *.html ./
COPY README.md ./

# Set up APL environment
ENV APLCICD_HOME=/app/aplcicd
ENV PATH=$PATH:/app/aplcicd

# Create non-root user for security
RUN useradd -m -s /bin/bash apluser
RUN chown -R apluser:apluser /app/aplcicd
USER apluser

# Validate installation
RUN dyalog -script -e "⎕FIX'file://APLCICD.dyalog' ⋄ APLCICD.ValidateInstallation"

# Expose web interface port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD dyalog -script -e "APLCICD.HealthCheck" || exit 1

# Default command
CMD ["dyalog", "-script", "-e", "⎕FIX'file://APLCICD.dyalog' ⋄ APLCICD.StartServer 8080"]