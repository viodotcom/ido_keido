~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :dev do
  set(dev_mode: true)
  set(include_erts: false)
  set(cookie: :"A(:nfZ}qqAnz,OqU*St^1`k]rE~>tvjWPmSanPtAeYL*38H*VsifXINLzw(PpkB!")

  set(
    config_providers: [
      {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
    ]
  )
end

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"U(]8t0LcMwX5$`136AY3LXW<q^CW/sW6QB1XE})atHN]*]ul1h1G%a,2_pn)>bUQ")
  set(vm_args: "rel/vm.args")

  set(
    config_providers: [
      {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
    ]
  )
end

release :ido_keido do
  set(version: current_version(:ido_keido))

  set(
    applications: [
      :runtime_tools
    ]
  )

  set(
    overlays: [
      {:copy, "rel/config/config.exs", "etc/config.exs"}
    ]
  )
end
