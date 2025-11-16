# Solução para Erro de Java

## Problema
O projeto requer Java 11 ou superior, mas o sistema está usando Java 8.

## Soluções

### Opção 1: Instalar Java 11+ (Recomendado)

1. **Baixar Java 11 ou superior:**
   - Oracle JDK: https://www.oracle.com/java/technologies/downloads/
   - OpenJDK (Adoptium): https://adoptium.net/
   - Recomendado: OpenJDK 17 LTS (mais estável)

2. **Instalar o JDK:**
   - Baixe o instalador Windows (.msi)
   - Execute e siga as instruções
   - Durante a instalação, marque a opção para adicionar ao PATH

3. **Verificar instalação:**
   ```powershell
   java -version
   ```
   Deve mostrar versão 11 ou superior.

4. **Configurar JAVA_HOME (se necessário):**
   ```powershell
   # Verificar onde o Java foi instalado (geralmente em C:\Program Files\Java\jdk-XX)
   $env:JAVA_HOME = "C:\Program Files\Java\jdk-17"  # Ajuste o caminho conforme necessário
   ```

### Opção 2: Usar Flutter no Windows (Temporário)

Enquanto não instala o Java 11+, você pode executar o app no Windows:

```powershell
flutter run -d windows
```

### Opção 3: Configurar local.properties (Se tiver Java 11+ em outro local)

Se você já tiver Java 11+ instalado em outro local, adicione ao arquivo `android/local.properties`:

```
org.gradle.java.home=C:\\caminho\\para\\java\\jdk-11
```

## Verificar versão atual do Java

```powershell
java -version
```

## Após instalar Java 11+

1. Feche e reabra o terminal
2. Execute:
   ```powershell
   flutter clean
   flutter pub get
   flutter run
   ```

