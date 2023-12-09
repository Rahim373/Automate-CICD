#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Automate.Api/Automate.Api.csproj", "Automate.Api/"]
RUN dotnet restore "Automate.Api/Automate.Api.csproj"
COPY . .
WORKDIR "/src/Automate.Api"
RUN dotnet build "Automate.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Automate.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "Automate.Api.dll"]