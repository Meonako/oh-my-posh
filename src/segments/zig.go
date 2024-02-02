package segments

import (
	"github.com/jandedobbeleer/oh-my-posh/src/platform"
	"github.com/jandedobbeleer/oh-my-posh/src/properties"
)

type Zig struct {
	language
}

func (z *Zig) Template() string {
	return languageTemplate
}

func (z *Zig) Init(props properties.Properties, env platform.Environment) {
	z.language = language{
		env:        env,
		props:      props,
		extensions: []string{"*.zig", "build.zig"},
		commands: []*cmd{
			{
				executable: "zig",
				args:       []string{"version"},
				regex:      "(?P<version>(?P<major>[0-9]+).(?P<minor>[0-9]+)(?:.(?P<patch>[0-9]+))?(?:-dev)?(?:.(?P<buildmetadata>[a-zA-Z0-9]+))?)",
			},
		},
	}
}

func (z *Zig) Enabled() bool {
	return z.language.Enabled()
}
