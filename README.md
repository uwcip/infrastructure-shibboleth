# infrastructure-shibboleth
A container for running shibd for Apache. This container is meant to run in a
Kubernetes pod that also includes an Apache instance.

To correctly use Apache and shibd you will need to share the configuration for
shibd between both containers in the pod. To that end, this container expects
that you will keep the shibd configuration in your Apache container and then
share that configuration with this container using an emptyDir. See the example
directory for a Kubernetes configuration file and an Apache configuration file.

Whatever your shibboleth configuration, be sure to specify this in your
`shibboleth2.xml` file so that shibd connects over TCP instead of over a Unix
socket.

    <TCPListener address="127.0.0.1" port="1600" acl="127.0.0.1"/>

Finally, shibd is a memory hog so be sure to give it adequate memory.
