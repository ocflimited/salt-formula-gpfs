%global service gpfs

Summary: %{service} salt formula
Name: salt-formula-%{service}
Version: %{?version:%{version}}%{!?version:%(cat VERSION)}
URL: https://gitlab.ocf.co.uk/salt/salt-formula-%{service}
Release: %{?release:%{release}}%{!?release:%(cat RELEASE)}
License: ASL 2.0
Requires: salt-master salt-ocf salt-formula-ofed
BuildArch: noarch
Source: salt-formula-%{service}.tgz

Requires(preun): systemd
Requires(postun): systemd

%description
Install and configure %{service}

%prep
%setup -q -n %{name}

%install
install -d -m 755 %{buildroot}/usr/share/salt-formulas/env/%{service}/files

cp -r %{service}/files/* %{buildroot}/usr/share/salt-formulas/env/%{service}/files/.

install -D -m 644 %{service}/*.sls %{buildroot}/usr/share/salt-formulas/env/%{service}/
install -D -m 644 %{service}/*.jinja %{buildroot}/usr/share/salt-formulas/env/%{service}/
install -D -m 644 %{service}/*.yaml %{buildroot}/usr/share/salt-formulas/env/%{service}/

mkdir -p %{buildroot}/etc/salt/master.d
cp etc/%{service}-master.d.conf %{buildroot}/etc/salt/master.d/%{service}.conf

%files
%license LICENSE
%doc README.rst
%doc CHANGELOG.rst
%doc VERSION
%doc pillar.example
/usr/share/salt-formulas/env/%{service}/
/etc/salt/master.d/%{service}.conf

%preun
%systemd_preun salt-master.service

%postun
%systemd_postun_with_restart salt-master.service

%changelog
* Sun Mar 12 2017 Arif ali <aali@ocf.co.uk>
0.0.1-1
- Initial release
