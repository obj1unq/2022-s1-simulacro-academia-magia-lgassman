/** Reemplazar por la solución del enunciado */



object fenix{
	method aporteUtilidad(cosa) {
		return if(cosa.reliquia()) 3 else 0
	}
}

object cuchuflito {
	method aporteUtilidad(cosa) {
		return 0
	}
	
}

object acme {
	method aporteUtilidad(cosa) {
		return cosa.volumen() / 2	
	}
	
}

class Cosa {
	const property volumen
	const property magica
	const property reliquia
	const property marca
	
	method utilidad() {
		return volumen + self.aporteMagico() + self.aporteReliquia() + marca.aporteUtilidad(self)
	}
	
	method aporteMagico() {
		return if (magica) 3 else 0	
	}
	
	method aporteReliquia() {
		return if (reliquia) 5 else 0
	}
	
	
}

class Academia {
	
	var property muebles = #{}
	
	method estaGuardado(cosa) {
		return muebles.any({mueble => mueble.estaGuardado(cosa)})
	}
	
	method dondeSeGuarda(cosa) {
		return muebles.find({mueble => mueble.estaGuardado(cosa)})	
	}
	
	method puedeGuardar(cosa) {
		return not self.estaGuardado(cosa) and self.entraEnUnMueble(cosa)
	}
	
	method entraEnUnMueble(cosa) {
		return muebles.any({mueble => mueble.puedeGuardar(cosa)})
	}
	
	method dondeGuardar(cosa) {
		return muebles.filter({mueble => mueble.puedeGuardar(cosa)})
	}
	
	
	method validarGuardar(cosa) {
		if(not self.puedeGuardar(cosa)) {
			self.error("No se puede guardar La cosa")
		}
	}
	method guardar(cosa) {
		self.validarGuardar(cosa)
		self.muebleCandidato(cosa).guardar(cosa)
	}
	
	method muebleCandidato(cosa) {
		return self.dondeGuardar(cosa).anyOne()
	}
	
	method menosUtiles() {
		return muebles.map({mueble => mueble.menosUtil()}).asSet()
	}
	
	method marcaMenosUtil() {
		return self.menosUtiles().min({cosa => cosa.utilidad()}).marca()
	}
	
	method removerMenosUtilesNoMagicos() {
		self.validarRemoverMenosUtilesNoMagicos()
		self.removibles().forEach({cosa => self.remover(cosa)})
	}
	method removibles() {
		return self.menosUtiles().filter({cosa => not cosa.magica()})
	}
	
	method validarRemoverMenosUtilesNoMagicos() {
		if(muebles.size() < 3) {
			self.error("No se puede remover los menos utiles no magicos")
		}	
	}
	
	method remover(cosa) {
		self.dondeSeGuarda(cosa).remover(cosa)	
	}
}

class Mueble {
	const cosas = #{}
	
	method remover(cosa) {
		cosas.remove(cosa)
	}
	
	method estaGuardado(cosa) {
		return cosas.contains(cosa)
	}
	
	method puedeGuardar(cosa) 
	
	method validarGuardar(cosa) {
		if(not self.puedeGuardar(cosa)) {
			self.error("no se puede guardar en el mueble esto: " + cosa)
		}
	}
	
	method guardar(cosa) {
		self.validarGuardar(cosa)
		cosas.add(cosa)
	}
	
	method utilidad() {
		return self.sumaUtilidadesCosas() / self.precio()
	}
	
	method sumaUtilidadesCosas() {
		return cosas.sum({cosa => cosa.utilidad()})
	}
	
	method precio()
	
	method menosUtil() {
		return cosas.min({cosa => cosa.utilidad()})
	}
}

class Gabinete inherits Mueble{
	const precio
	
	override method puedeGuardar(cosa) {
		return cosa.magica()
	}
	
	override method precio() {
		return precio
	}
}

class Armario inherits Mueble {
	var property capacidadMaxima
	
	override method puedeGuardar(cosa) {
		return self.hayEspacio()
	}	
	
	method hayEspacio() {
		return cosas.size() < capacidadMaxima	
	}
	override method precio() {
		return 5 * capacidadMaxima
	}
}

class Baul inherits Mueble {
	
	const volumenMaximo
	
	override method puedeGuardar(cosa) {
		return self.volumenUsado() + cosa.volumen() <= volumenMaximo
	}
	
	method volumenUsado() {
		return cosas.sum({cosa => cosa.volumen()})
	}	
	
	override method precio() {
		return volumenMaximo + 2
	}
	
	override method utilidad() {
		return super() + self.extraPorReliquias()
	}
	
	method extraPorReliquias() {
		return if (self.todasReliquias()) 2 else 0
	}
	
	method todasReliquias() {
		return cosas.all({cosa => cosa.reliquia()})
	}
	
	
}

class BaulMagico inherits Baul {
	
	override method utilidad() {
		return super() + self.cantidadCosasMagicas()
	}
	
	method cantidadCosasMagicas() {
		return cosas.count({cosa => cosa.magica()})
	}
	
	override method precio(){
		return super() * 2
	}
}


