using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System;
using System.Collections.Generic;
using System.Linq;

namespace MakroBoard.Extensions
{
    internal static class ModelConverter
    {
        public static ApiModels.Plugin ToApiPlugin(this PluginContract.IMakroBoardPlugin plugin, IEnumerable<PluginContract.Control> controls)
        {
            return new ApiModels.Plugin(plugin.SymbolicName, plugin.Title.ToApiLocalizableString(), plugin.PluginIcon, controls.Select(ToApiControl));
        }

        public static ApiModels.LocalizableString ToApiLocalizableString(this PluginContract.LocalizableString localizableString)
        {
            if (localizableString == null)
            {
                return null;
            }

            return new ApiModels.LocalizableString(localizableString.LocaleStrings.ToDictionary(l => l.Key.Name, l => l.Value, StringComparer.OrdinalIgnoreCase));
        }

        public static ApiModels.EnumItems ToApiEnumItems(this IReadOnlyCollection<EnumConfigParameter.EnumItem> enumItems)
        {
            return new ApiModels.EnumItems(enumItems.Select(e => e.ToApiEnumItem()).ToList());
        }

        public static ApiModels.EnumItem ToApiEnumItem(this EnumConfigParameter.EnumItem enumItem)
        {
            return new ApiModels.EnumItem(enumItem.Id, enumItem.Label.ToApiLocalizableString());
        }

        public static ApiModels.Control ToApiControl(this PluginContract.Control control)
        {
            return new ApiModels.Control(control.SymbolicName, control.View.ToApiView(), ToApiConfigParameters(control.ConfigParameters), control is PluginContract.ListControl listControl ? listControl.SubControls.Select(ToApiControl) : null);
        }

        public static ApiModels.View ToApiView(this View view)
        {
            return new ApiModels.View(view.Type.ToString(),
                view.ConfigParameters.ToApiConfigParameters(),
                view.PluginParameters.ToApiConfigParameters(),
                view is ListView lv ? lv.SubViews.Select(ToApiView).ToList() : null);
        }

        public static ApiModels.ConfigParameters ToApiConfigParameters(this ConfigParameters configParameters)
        {
            return new ApiModels.ConfigParameters(configParameters.Select(ToApiConfigParameter).ToList());
        }

        public static ApiModels.ConfigParameter ToApiConfigParameter(this ConfigParameter configParameter)
        {
            return configParameter switch
            {
                StringConfigParameter scp => new ApiModels.ConfigParameter(configParameter.SymbolicName, configParameter.Label.ToApiLocalizableString(), scp.DefaultValue, scp.ValidationRegEx),
                IntConfigParameter icp => new ApiModels.ConfigParameter(configParameter.SymbolicName, configParameter.Label.ToApiLocalizableString(), icp.MinValue, icp.MaxValue),
                BoolConfigParameter bcp => new ApiModels.ConfigParameter(configParameter.SymbolicName, configParameter.Label.ToApiLocalizableString(), bcp.DefaultValue),
                EnumConfigParameter ecp => new ApiModels.ConfigParameter(configParameter.SymbolicName, configParameter.Label.ToApiLocalizableString(), ecp.EnumItems.ToApiEnumItems(), ecp.DefaultEnumItemId),
                _ => throw new ArgumentOutOfRangeException(nameof(configParameter), $"ConfigParameterType {configParameter.GetType().FullName} is not yet supported!"),
            };
        }
    }
}
