# SFTPGo Service

Servicio SFTP basado en [SFTPGo](https://github.com/drakkan/sftpgo) usando Docker.

## Estructura

- `docker-compose.yml` — definición del servicio.
- `.env` — puertos y credenciales del admin web.
- `users.json` — usuarios SFTP predefinidos, cargados automáticamente al iniciar.
- `storage/` — carpetas home de cada usuario (persistente).
- `data/` — datos internos de SFTPGo (base de datos, config).
- `backups/` — backups internos de SFTPGo.

## Uso

1. Edita `users.json` para definir tus usuarios (username, password u otras opciones de auth, home_dir).
   Por cada usuario nuevo, crea también su carpeta en `storage/<username>`.
2. Ajusta `.env` si quieres cambiar puertos o credenciales del panel admin.
3. Levanta el servicio:

   ```bash
   docker compose up -d
   ```

4. Conéctate por SFTP:

   ```bash
   sftp -P 2022 demo1@localhost
   ```

5. Panel de administración web: http://localhost:8080 (usuario/clave definidos en `.env`).

## Notas

- Los usuarios en `users.json` solo se cargan la primera vez que arranca el contenedor (o si cambias `SFTPGO_LOADDATA_MODE`). Para forzar recarga tras editar `users.json`, revisa la [documentación de loaddata](https://docs.sftpgo.com/latest/custom-actions/#loaddata) de SFTPGo.
- Las contraseñas de ejemplo (`demo1_password`, `demo2_password`) y la del admin (`changeme`) deben cambiarse antes de usar en producción.
- Para usar autenticación por clave pública en lugar de password, añade el campo `"public_keys": ["ssh-rsa ..."]` al usuario en `users.json`.
