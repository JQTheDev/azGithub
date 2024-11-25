FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["azureaci/azureaci.csproj", "azureaci/"]
RUN dotnet restore "azureaci/azureaci.csproj"
COPY . .
WORKDIR "/src/azureaci"
RUN dotnet build "azureaci.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "azureaci.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "azureaci.dll"]
