using EntityFrameworkCore.Triggers;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using ReactiveUI;
using System;
using System.Collections.Generic;
using System.Linq;
using WebMacroSoftKeyboard.Data;

namespace WebMacroSoftKeyboard.UI.ViewModels
{
    public class MainWindowViewModel : ViewModelBase
    {
        private IServiceProvider _Services;
        private ClientContext _ClientContext;
        private Client _LastClientRequest;

        public IEnumerable<Client> Clients { get; }

        public Client LastClientRequest { get => _LastClientRequest; set => this.RaiseAndSetIfChanged(ref _LastClientRequest, value); }

        public MainWindowViewModel(IServiceProvider services)
        {
            _Services = services;
            _ClientContext = _Services.GetRequiredService<ClientContext>();
            Clients = _ClientContext.Clients;//.AsObservableChangeSet();
            Triggers<Client>.Inserted += ClientInserted;
        }

        private void ClientInserted(IInsertedEntry<Client, DbContext> obj)
        {
            LastClientRequest = obj.Entity;
            this.RaisePropertyChanged(nameof(LastClientRequest));
        }

     

        public string Greeting => "Welcome to Avalonia!";
    }
}
