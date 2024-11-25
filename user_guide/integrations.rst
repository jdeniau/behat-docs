Integrations
============

Behat can be integrated with a large number of other projects and frameworks to enhance its
capabilities. We'll mention here the main integrations that may prove useful in your projects:

Mink
----

Behat can be used to describe the business logic of many different projects, but one of the
main uses is for web applications where it can be used to provide functional testing. `Mink`_
is a library which lets you control or emulate a web browser and which lets you simulate the
interactions of users with a web page. It supports a number of drivers for tools like
Selenium, BrowserKit, and Chrome DevTools Protocol to implement these capabilities

`Mink Extension`_ is a Behat extension that lets you interact with Mink from Behat, providing
additional services like ``Sessions`` or ``Drivers`` and providing a number of base step
definitions and hooks for your contexts. See the documentation of the extension for more info
and usage.

Symfony
-------

Symfony integration is provided by the `Symfony Extension`_. This extension provides an
integration with your Symfony project, including the capability to define your contexts as
regular Symfony services, autowiring and autoconfiguring of your contexts and using Mink
with a dedicated Symfony driver that allows you to test your application by interacting
directly with the Symfony kernel without having to create real HTTP requests. See the
documentation of the extension for more info and usage.

Drupal
------

Drupal integration is provided by the `Drupal Extension`_. This extension provides an
integration with your Drupal project, including using Mink to access your Drupal site using
Guzzle and a number of useful step definitions for common testing scenarios specific to
Drupal. See the documentation of the extension for more info and usage.

.. _`Mink`: https://mink.behat.org/
.. _`Mink Extension`: https://github.com/FriendsOfBehat/MinkExtension
.. _`Symfony Extension`: https://github.com/FriendsOfBehat/SymfonyExtension
.. _`Drupal Extension`: https://github.com/jhedstrom/drupalextension
