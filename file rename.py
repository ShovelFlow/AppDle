import argparse
import re
from pathlib import Path
import uuid


def transform_name(name: str) -> str:
	name = re.sub(r"^\d+px-", "", name)
	name = re.sub(r"_[^_]*\.png$", ".png", name)
	name = name.replace("_", " ", 9)
	return name.upper()


def unique_destination_name(folder: Path, desired_name: str, used_names: set[str]) -> Path:
	desired_path = folder / desired_name
	if desired_path.name not in used_names and not desired_path.exists():
		used_names.add(desired_path.name)
		return desired_path

	stem = desired_path.stem
	suffix = desired_path.suffix
	index = 2
	while True:
		candidate = folder / f"{stem}_{index}{suffix}"
		if candidate.name not in used_names and not candidate.exists():
			used_names.add(candidate.name)
			return candidate
		index += 1


def rename_files(folder: Path, dry_run: bool) -> None:
	if not folder.is_dir():
		raise ValueError(f"La ruta no es una carpeta válida: {folder}")

	files = sorted(p for p in folder.iterdir() if p.is_file())

	if not files:
		print("No se encontraron archivos en la carpeta.")
		return

	planned = []
	used_names: set[str] = set()
	for file_path in files:
		new_name = transform_name(file_path.name)
		if not new_name:
			raise ValueError(f"El nombre generado quedó vacío para: {file_path.name}")
		planned.append((file_path, unique_destination_name(folder, new_name, used_names)))

	if dry_run:
		print("Modo simulación. Estos cambios se aplicarían:")
		for old_path, new_path in planned:
			print(f"{old_path.name} -> {new_path.name}")
		return

	temp_paths = []
	for index, (old_path, _) in enumerate(planned):
		temp_path = folder / f".tmp_rename_{index}_{uuid.uuid4().hex}"
		old_path.replace(temp_path)
		temp_paths.append(temp_path)

	for temp_path, (_, final_path) in zip(temp_paths, planned):
		temp_path.replace(final_path)
		print(f"{temp_path.name} -> {final_path.name}")


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Renombrar archivos en masa dentro de una carpeta")
	parser.add_argument("folder", help="Ruta de la carpeta")
	parser.add_argument("--dry-run", action="store_true", help="Mostrar cambios sin renombrar")
	args = parser.parse_args()

	rename_files(Path(args.folder), args.dry_run)
