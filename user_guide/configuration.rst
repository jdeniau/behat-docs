Configuration
=============

Behat has a very powerful configuration system based on ``YAML`` configuration files and
profiles.

.. toctree::
   :maxdepth: 2

   configuration/suites.rst

``behat.yml``
-------------

All configuration happens inside a single configuration file in the ``YAML``
format. By default, Behat loads the configuration from the first file matching:

* ``behat.yaml`` or ``behat.yml``
* ``behat.yaml.dist`` or ``behat.yml.dist``
* ``behat.dist.yaml`` or ``behat.dist.yml``
* ``config/behat.yaml`` or ``config/behat.yml``
* ``config/behat.yaml.dist`` or ``config/behat.yml.dist``
* ``config/behat.dist.yaml`` or ``config/behat.dist.yml``

You can also tell Behat where your config file is with the ``--config`` option:

.. code-block:: bash

    $ behat --config custom-config.yml

All configuration parameters in that file are defined under a profile name root
(``default:`` for example). A profile is just a custom name you can use to
quickly switch testing configuration by using the ``--profile`` option when
executing your feature suite.

The default profile is always ``default``. All other profiles inherit
parameters from the ``default`` profile. If you only need one profile, define
all of your parameters under the ``default:`` root:

.. code-block:: yaml

    # behat.yml
    default:
        #...

Overriding ``default`` params
-----------------------------

Each profile is an extension of the ``default`` profile. This means you can
define a new profile that overrides configuration parameters defined in the
``default`` profile.

Let's assume we have a ``default`` profile as such:

.. code-block:: yaml

    # behat.yml
    default:
        suites:
            default:
                filters:
                    tags: "@runthisonlyondefault"

Now we want a profile that changes the tag which is to be run in the default
suite. We can add the profile and just override:

.. code-block:: yaml

    # behat.yml
    default:
        suites:
            default:
                filters:
                    tags: "@runthisonlyondefault"

    profile1:
        suites:
            default:
                filters:
                    tags: "@runthisonlyonprofile1"

Or maybe we want to unset the tag filter for a profile:

.. code-block:: yaml

    # behat.yml
    default:
        suites:
            default:
                filters:
                    tags: "@runthisonlyondefault"

    profile1:
        suites:
            default:
                filters: ~

Importing Config
----------------

The ``imports`` block can be used to merge multiple configuration files in to one loaded config in Behat, using the following syntax:

.. code-block:: yaml

    # behat.yml
    imports:
        - config/base.behat.yml
        - config/ci.behat.yml

All files from the ``imports`` block will be loaded by Behat and merged, in the listed order, into your ``behat.yml`` config. This is especially useful when you want to tweak configuration slightly between local development and on Continuous Integration environments by using partial configuration files.

This allows configuration files listed in the ``imports`` key to override configuration values for previously listed files.

Environment Variable - BEHAT_PARAMS
-----------------------------------

If you want to set up configurable Behat settings, use the ``BEHAT_PARAMS``
environment variable:

.. code-block:: bash

    export BEHAT_PARAMS='{"extensions" : {"Behat\\MinkExtension" : {"base_url" : "https://www.example.com/"}}}'

You can set any value for any option that is available in a ``behat.yml`` file.
Just provide options in *JSON* format.  Behat will use those options as defaults.
You can always override them with the settings in the project ``behat.yml`` file (it has higher priority).

.. tip::

    In order to specify a parameter in an environment variable, the value *must not* exist in your ``behat.yml``

.. tip::

    NOTE: In Behat 2.x this variable was in *URL* format.  It has been changed to use *JSON* format.

Global Filters
--------------

While it is possible to specify filters as part of suite configuration, sometimes you will want to
exclude certain scenarios across the suite, with the option to override the filters at the command line.

This is achieved by specifying the filter in the `gherkin` configuration:

.. code-block:: yaml

    # behat.yml

    default:
        gherkin:
            filters:
                tags: ~@wip

In this instance, scenarios tagged as `@wip` will be ignored unless the CLI command is run with a custom filter, e.g.:

.. code-block:: bash

    vendor/bin/behat --tags=wip

Custom Autoloading
------------------

Sometimes you will need to place your ``features`` folder somewhere other than the
default location (e.g. ``app/features``). All you need to do is specify the path
you want to autoload via ``behat.yml``:

.. code-block:: yaml

    # behat.yml

    default:
        autoload:
            '': %paths.base%/app/features/bootstrap

If you wish to namespace your features (for example: to be PSR-1 compliant) you will need to add the namespace to the classes and also tell behat where to load them. Here ``contexts`` is an array of classes:

.. code-block:: yaml


    # behat.yml

    default:
        autoload:
            '': %paths.base%/app/features/bootstrap
        suites:
            default:
                contexts: [My\Application\Namespace\Bootstrap\FeatureContext]

.. note::

    Using ``behat.yml`` to autoload will only allow for ``PSR-0``.
    You can also use ``composer.json`` to autoload, which will also
    allow for ``PSR-4``

Formatters
----------

Default formatters can be enabled by specifying them in the profile.

.. code-block:: yaml

    # behat.yml

    default:
        formatters:
            pretty: true

Extensions
----------

Extensions can be configured like this:

.. code-block:: yaml

    # behat.yml

    default:
    	extensions:
            Behat\MinkExtension:
                base_url: http://www.example.com
            	selenium2: ~
